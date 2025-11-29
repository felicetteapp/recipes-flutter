package app.felicette.recipes.data.service

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.*
import app.felicette.recipes.data.model.WearIngredient
import kotlinx.coroutines.tasks.await
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class PhoneDataLayerRepository private constructor(context: Context) {

    private val dataClient: DataClient = Wearable.getDataClient(context)
    private val messageClient: MessageClient = Wearable.getMessageClient(context)
    private val nodeClient: NodeClient = Wearable.getNodeClient(context)
    private val applicationContext = context.applicationContext

    private val json = Json {
        ignoreUnknownKeys = true
        encodeDefaults = true
        prettyPrint = false
    }

    suspend fun sendIngredientsToWatch(ingredients: List<WearIngredient>) {
        try {
            Log.d(TAG, "Sending ${ingredients.size} ingredients to watch")
            
            val ingredientsJson = json.encodeToString(ingredients)
            Log.v(TAG, "Serialized JSON (${ingredientsJson.length} chars): $ingredientsJson")
            
            val putDataReq = PutDataMapRequest.create(INGREDIENTS_PATH).apply {
                dataMap.putString(INGREDIENTS_KEY, ingredientsJson)
                dataMap.putLong(TIMESTAMP_KEY, System.currentTimeMillis())
            }

            val request = putDataReq.asPutDataRequest().setUrgent()
            val result = dataClient.putDataItem(request).await()
            
            Log.d(TAG, "Ingredients sent successfully: ${result.uri}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to send ingredients to watch", e)
            throw SendToWatchException("Failed to send ingredients", e)
        }
    }

    suspend fun requestSyncFromWatch() {
        try {
            val nodes = getConnectedNodes()
            
            if (nodes.isEmpty()) {
                Log.w(TAG, "No connected watches to sync with")
                return
            }
            
            nodes.forEach { node ->
                try {
                    messageClient.sendMessage(
                        node.id,
                        INGREDIENTS_REQUEST_PATH,
                        null
                    ).await()
                    Log.d(TAG, "Sync request sent to ${node.displayName} (${node.id})")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to send sync request to ${node.displayName}", e)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to request sync from watch", e)
        }
    }


    suspend fun hasConnectedWatch(): Boolean {
        return try {
            getConnectedNodes().isNotEmpty()
        } catch (e: Exception) {
            Log.e(TAG, "Error checking connected watches", e)
            false
        }
    }


    suspend fun getConnectedNodes(): List<Node> {
        return try {
            nodeClient.connectedNodes.await().also { nodes ->
                Log.d(TAG, "Found ${nodes.size} connected nodes")
                nodes.forEach { node ->
                    Log.v(TAG, "  - ${node.displayName} (${node.id})")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to get connected nodes", e)
            emptyList()
        }
    }

    suspend fun getWatchCapabilities(): Set<Node> {
        return try {
            val capabilityClient = Wearable.getCapabilityClient(applicationContext)
            val capabilityInfo = capabilityClient
                .getCapability(WEAR_CAPABILITY, CapabilityClient.FILTER_REACHABLE)
                .await()
            
            capabilityInfo.nodes.also { nodes ->
                Log.d(TAG, "Found ${nodes.size} nodes with capability '$WEAR_CAPABILITY'")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to get watch capabilities", e)
            emptySet()
        }
    }

    companion object {
        private const val TAG = "PhoneDataRepository"
        
        private const val INGREDIENTS_PATH = "/ingredients"
        private const val INGREDIENTS_KEY = "ingredients_data"
        private const val TIMESTAMP_KEY = "timestamp"
        private const val INGREDIENTS_REQUEST_PATH = "/ingredients/request"
        private const val INGREDIENT_STATUS_PATH = "/ingredient/status"
        
        private const val WEAR_CAPABILITY = "felicette_recipes_wear"

        @Volatile
        private var instance: PhoneDataLayerRepository? = null

        fun getInstance(context: Context): PhoneDataLayerRepository {
            return instance ?: synchronized(this) {
                instance ?: PhoneDataLayerRepository(context).also { 
                    instance = it 
                }
            }
        }
    }
}

class SendToWatchException(message: String, cause: Throwable? = null) : Exception(message, cause)
