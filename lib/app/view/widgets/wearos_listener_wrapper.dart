import 'dart:async';
import 'dart:developer';

import 'package:felicette_recipes/app/services/wearos/wearos_service.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WearOsListenerWrapper extends StatefulWidget {
  const WearOsListenerWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<WearOsListenerWrapper> createState() => WearOsListenerWrapperState();
}

class WearOsListenerWrapperState extends State<WearOsListenerWrapper> {
  StreamSubscription<IngredientStatusUpdateEvent>? _wearOsSubscription;
  StreamSubscription<IngredientsRequestEvent>? _wearOsRequestSubscription;

  @override
  void initState() {
    super.initState();
    _initializeWearOsListeners();
  }

  void _initializeWearOsListeners() {
    log('Initializing WearOS listener', name: '_WearOsListenerWrapper');
    final listBloc = context.read<ListBloc>();

    _wearOsRequestSubscription = WearOSService.instance.ingredientsRequests
        .listen(
          (event) {
            log(
              'WearOS ingredients request received',
              name: '_WearOsListenerWrapper',
            );

            final currentIngredients = listBloc
                .state
                .listItemsAsIngredientDisplayType
                .where((item) {
                  return item.type == .ingredient;
                })
                .map(
                  (item) => item.ingredientItem!,
                )
                .toList();

            if (!context.mounted) return;

            // ignore: use_build_context_synchronously
            final s = S.of(context);

            WearOSService.instance.sendCurrentIngredients(
              currentIngredients: currentIngredients,
              s: s,
            );
          },
        );

    _wearOsSubscription = WearOSService.instance.ingredientStatusUpdates.listen(
      (event) {
        log(
          'WearOS ingredient status update: ${event.ingredientId}',
          name: '_WearOsListenerWrapper',
        );

        if (context.mounted) {
          listBloc.add(
            ToggleIngredientCheckedStatus(
              event.ingredientId,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _wearOsSubscription?.cancel();
    _wearOsRequestSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
