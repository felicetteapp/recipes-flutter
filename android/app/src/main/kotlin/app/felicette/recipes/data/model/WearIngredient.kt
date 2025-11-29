package app.felicette.recipes.data.model

import kotlinx.serialization.Serializable

/**
 * Data model for recipe ingredients shared between phone and WearOS app.
 * Must match the WearOS app's Ingredient model exactly.
 */
@Serializable
data class WearIngredient(
    val id: String,
    val name: String,
    val description: String,
    val isChecked: Boolean = false
)
