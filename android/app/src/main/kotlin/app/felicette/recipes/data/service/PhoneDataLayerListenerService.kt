package app.felicette.recipes.data.service

import android.util.Log
import com.google.android.gms.wearable.*
import app.felicette.recipes.data.model.WearIngredient
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

/**
 * Background service that listens for messages and data changes from WearOS devices.
 * This service handles:
 * - Ingredient requests from the watch
 * - Status updates (check/uncheck) from the watch
 * - Communication with Flutter via MethodChannel
 */
class PhoneDataLayerListenerService : WearableListenerService() {

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private var methodChannel: MethodChannel? = null

    companion object {
        private const val TAG = "PhoneDataListener"
        private const val CHANNEL = "app.felicette.recipes/wearos"
        private const val INGREDIENTS_REQUEST_PATH = "/ingredients/request"
        private const val INGREDIENT_STATUS_PATH = "/ingredient/status"
        
        // Static reference to MainActivity's FlutterEngine
        // This is set by MainActivity when it's created
        var flutterEngine: FlutterEngine? = null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "PhoneDataLayerListenerService created")
        
        // Initialize MethodChannel if FlutterEngine is available
        flutterEngine?.let { engine ->
            methodChannel = MethodChannel(
                engine.dartExecutor.binaryMessenger,
                CHANNEL
            )
            Log.d(TAG, "MethodChannel initialized successfully")
        } ?: run {
            Log.w(TAG, "FlutterEngine not available, will use mocked data")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
        Log.d(TAG, "PhoneDataLayerListenerService destroyed")
    }

    /**
     * Called when the watch sends a message to the phone.
     * Handles ingredient requests from the watch.
     */
    override fun onMessageReceived(messageEvent: MessageEvent) {
        Log.d(TAG, "Message received from ${messageEvent.sourceNodeId}")
        Log.d(TAG, "  Path: ${messageEvent.path}")
        Log.d(TAG, "  Data: ${messageEvent.data?.size ?: 0} bytes")
        
        when (messageEvent.path) {
            INGREDIENTS_REQUEST_PATH -> {
                Log.d(TAG, "Watch requested ingredients")
                serviceScope.launch {
                    sendIngredientsToWatch()
                }
            }
            else -> {
                Log.d(TAG, "Unknown message path: ${messageEvent.path}")
            }
        }
    }

    /**
     * Called when data items change (sent from watch).
     * Handles ingredient status updates (check/uncheck) from the watch.
     */
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        Log.d(TAG, "Data changed event received: ${dataEvents.count} events")
        
        dataEvents.forEach { dataEvent ->
            Log.d(TAG, "  Event type: ${dataEvent.type}, Path: ${dataEvent.dataItem.uri.path}")
            
            when (dataEvent.dataItem.uri.path) {
                INGREDIENT_STATUS_PATH -> {
                    if (dataEvent.type == DataEvent.TYPE_CHANGED) {
                        handleIngredientStatusUpdate(dataEvent)
                    }
                }
                else -> {
                    Log.d(TAG, "Unknown data path: ${dataEvent.dataItem.uri.path}")
                }
            }
        }
        
        dataEvents.release()
    }

    /**
     * Handle ingredient status update (check/uncheck) from watch.
     * Extracts the data and forwards it to Flutter via MethodChannel.
     */
    private fun handleIngredientStatusUpdate(dataEvent: DataEvent) {
        try {
            Log.d(TAG, "Handling ingredient status update from watch")
            val dataMap = DataMapItem.fromDataItem(dataEvent.dataItem).dataMap
            val ingredientId = dataMap.getString("ingredient_id") ?: run {
                Log.e(TAG, "Ingredient ID is null in status update")
                return
            }
            val isChecked = dataMap.getBoolean("is_checked")
            val timestamp = dataMap.getLong("timestamp", 0)
            
            Log.d(TAG, "Ingredient status update:")
            Log.d(TAG, "  ID: $ingredientId")
            Log.d(TAG, "  Checked: $isChecked")
            Log.d(TAG, "  Timestamp: $timestamp")
            
            serviceScope.launch {
                updateIngredientStatusInFlutter(ingredientId, isChecked)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling ingredient status update", e)
        }
    }

    /**
     * Send ingredients to the watch.
     * Fetches ingredients from Flutter.
     */
    private suspend fun sendIngredientsToWatch() {
        try {
            val ingredients = if (methodChannel != null) {
                try {
                    Log.d(TAG, "Fetching ingredients from Flutter")
                    getIngredientsFromFlutter()
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to get ingredients from Flutter", e)    
                    emptyList<WearIngredient>()                
                }
            } else {
                Log.w(TAG, "MethodChannel not available")
                emptyList<WearIngredient>()
            }
            
            Log.d(TAG, "Sending ${ingredients.size} ingredients to watch")
            val repository = PhoneDataLayerRepository.getInstance(applicationContext)
            repository.sendIngredientsToWatch(ingredients)
            
            Log.d(TAG, "Successfully sent ${ingredients.size} ingredients to watch")
        } catch (e: Exception) {
            Log.e(TAG, "Error sending ingredients to watch", e)
        }
    }

    /**
     * Get ingredients from Flutter via MethodChannel.
     * This communicates with the Dart side to get the current ingredient list.
     */
    private suspend fun getIngredientsFromFlutter(): List<WearIngredient> {
        return withContext(Dispatchers.Main) {
            suspendCoroutine { continuation ->
                methodChannel?.invokeMethod(
                    "getIngredients",
                    null,
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            try {
                                @Suppress("UNCHECKED_CAST")
                                val ingredientsList = result as? List<Map<String, Any>>
                                    ?: emptyList()
                                
                                Log.d(TAG, "Received ${ingredientsList.size} ingredients from Flutter")
                                
                                val ingredients = ingredientsList.map { map ->
                                    WearIngredient(
                                        id = map["id"] as String,
                                        name = map["name"] as String,
                                        description = map["description"] as? String ?: "",
                                        isChecked = map["isChecked"] as? Boolean ?: false
                                    )
                                }
                                
                                continuation.resume(ingredients)
                            } catch (e: Exception) {
                                Log.e(TAG, "Error parsing ingredients from Flutter", e)
                                continuation.resumeWithException(e)
                            }
                        }

                        override fun error(code: String, message: String?, details: Any?) {
                            Log.e(TAG, "Error from Flutter: $code - $message")
                            continuation.resumeWithException(
                                Exception("$code: $message")
                            )
                        }

                        override fun notImplemented() {
                            Log.e(TAG, "Method not implemented in Flutter")
                            continuation.resumeWithException(
                                Exception("Method not implemented")
                            )
                        }
                    }
                ) ?: continuation.resumeWithException(
                    Exception("MethodChannel is null")
                )
            }
        }
    }

    /**
     * Update ingredient status in Flutter via MethodChannel.
     * This communicates with the Dart side to update the check status.
     */
    private suspend fun updateIngredientStatusInFlutter(
        ingredientId: String,
        isChecked: Boolean
    ) {
        withContext(Dispatchers.Main) {
            try {
                methodChannel?.invokeMethod(
                    "updateIngredientStatus",
                    mapOf(
                        "ingredientId" to ingredientId,
                        "isChecked" to isChecked
                    ),
                    object : MethodChannel.Result {
                        override fun success(result: Any?) {
                            Log.d(TAG, "Successfully updated ingredient $ingredientId in Flutter")
                        }

                        override fun error(code: String, message: String?, details: Any?) {
                            Log.e(TAG, "Error updating ingredient in Flutter: $code - $message")
                        }

                        override fun notImplemented() {
                            Log.e(TAG, "Update method not implemented in Flutter")
                        }
                    }
                )
            } catch (e: Exception) {
                Log.e(TAG, "Exception updating ingredient in Flutter", e)
            }
        }
    }

    /**
     * Called when a peer (watch) is connected.
     */
    override fun onPeerConnected(peer: Node) {
        super.onPeerConnected(peer)
        Log.d(TAG, "Peer connected: ${peer.displayName} (${peer.id})")
    }

    /**
     * Called when a peer (watch) is disconnected.
     */
    override fun onPeerDisconnected(peer: Node) {
        super.onPeerDisconnected(peer)
        Log.d(TAG, "Peer disconnected: ${peer.displayName} (${peer.id})")
    }
}
