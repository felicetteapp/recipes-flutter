package app.felicette.recipes

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import app.felicette.recipes.data.service.PhoneDataLayerListenerService
import app.felicette.recipes.data.service.PhoneDataLayerRepository
import app.felicette.recipes.data.model.WearIngredient
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

/**
 * Main Activity for the Felicette Recipes Flutter app.
 * Handles WearOS communication by making the FlutterEngine available to the service
 * and setting up MethodChannel handlers for Flutter-to-native communication.
 */
class MainActivity : FlutterActivity() {
    private val TAG = "MainActivity"
    private val CHANNEL = "app.felicette.recipes/wearos"
    private val activityScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Make FlutterEngine available to the PhoneDataLayerListenerService
        // This allows the service to use MethodChannel to communicate with Flutter
        PhoneDataLayerListenerService.flutterEngine = flutterEngine
        
        // Set up MethodChannel for Flutter-to-native communication
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "hasConnectedWatch" -> {
                    Log.d(TAG, "Flutter requested to check connected watch")
                    handleHasConnectedWatch(result)
                }
                "sendCurrentIngredients" -> {
                    Log.d(TAG, "Flutter requested to send current ingredients (not implemented)")
                    val ingredients = call.argument<List<Map<String, Any>>>("ingredients") ?: emptyList()
                    val wearIngredients = ingredients.map { map ->
                        WearIngredient(
                            id = map["id"] as String,
                            name = map["name"] as String,
                            description = map["description"] as String,
                            isChecked = map["isChecked"] as Boolean
                        )
                    }.toList()
                    handleSendCurrentIngredients(result, wearIngredients)
                }
                else -> {
                    Log.w(TAG, "Unknown method called: ${call.method}")
                    result.notImplemented()
                }
            }
        }
        
        Log.d(TAG, "FlutterEngine configured with MethodChannel handler")
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        
        // Clear the method call handler
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        
        // Clear the FlutterEngine reference when cleaning up
        PhoneDataLayerListenerService.flutterEngine = null
        
        Log.d(TAG, "FlutterEngine cleaned up")
    }

    private fun handleSendCurrentIngredients(result: MethodChannel.Result, ingredients: List<WearIngredient>) {
        activityScope.launch {
            try {
                Log.d(TAG, "Sending current ingredients to watch...")
                
                val repository = PhoneDataLayerRepository.getInstance(applicationContext)
                repository.sendIngredientsToWatch(ingredients)
                
                Log.d(TAG, "Successfully sent ${ingredients.size} current ingredients")
                result.success("Sent ${ingredients.size} ingredients")
            } catch (e: Exception) {
                Log.e(TAG, "Error sending current ingredients", e)
                result.error("SEND_ERROR", e.message, null)
            }
        }
    }

    /**
     * Handle request to check if a watch is connected.
     * This allows Flutter to update UI based on watch connectivity.
     */
    private fun handleHasConnectedWatch(result: MethodChannel.Result) {
        activityScope.launch {
            try {
                Log.d(TAG, "Checking for connected watch...")
                
                val repository = PhoneDataLayerRepository.getInstance(applicationContext)
                val nodes = repository.getConnectedNodes()
                val hasWatch = nodes.isNotEmpty()
                
                Log.d(TAG, "Connected watches: ${nodes.size}")
                nodes.forEach { node ->
                    Log.d(TAG, "  - ${node.displayName} (${node.id})")
                }
                
                result.success(hasWatch)
            } catch (e: Exception) {
                Log.e(TAG, "Error checking connected watch", e)
                result.error("CHECK_ERROR", e.message, null)
            }
        }
    }
}
