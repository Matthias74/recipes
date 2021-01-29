<script>

  const MATCHING_INGREDIENTS_HEIGHT = 125
  const RECIPES_LIST_HEIGHT = 300

  export default {
    data() {
      return {
        peopleQuantity: 1,
        ingredientName: null,
        selectedIngredients: [],
        recipes: [],
        isFetchingRecipes: false,
        displayRecipes: false,
        pagination: {
          totalPages: null,
          currentPage: 1
        }
      }
    },

    methods: {
      selectIngredient() {
        this.selectedIngredients.push(this.ingredientName)
        this.ingredientName = null
        this.resetRecipes()
      },

      removeIngredient(ingredient) {
        const ingredients = this.selectedIngredients.filter((selectedIngr) => selectedIngr !== ingredient)
        this.selectedIngredients = ingredients
        this.resetRecipes()
      },

      fetchMatchingRecipes() {
        const data = {
          people_quantity: this.peopleQuantity,
          ingredient_names: this.selectedIngredients,
          current_page: this.pagination.currentPage
        }

        $.ajax({
          method: "GET",
          url: "/recipes",
          data: data,
          success: (data) => {
            this.displayRecipes = true
            this.pagination.currentPage += 1
            this.pagination.totalPages = data.total_pages
            this.recipes = this.recipes.concat(data.recipes)
          }
        })
      },

      onRecipesScroll(event) {
        if(
            event.target.scrollHeight - event.target.scrollTop === RECIPES_LIST_HEIGHT &&
            this.pagination.currentPage < this.pagination.totalPages
          ) {
          this.fetchMatchingRecipes()
        }
      },

      selectedIngredientsHas(ingredient) {
        return !!this.selectedIngredients.find((selectedIngr) => {
          return ingredient.includes(selectedIngr)
        })
      },

      canSeachRecipes() {
        return this.selectedIngredients.length === 0 || this.isFetchingRecipes
      },

      resetRecipes() {
        this.displayRecipes = false
        this.recipes = []
        this.pagination.currentPage = 1
        this.pagination.totalPages = null
      }
    },

    watch: {
      peopleQuantity: function() {
        this.resetRecipes()
      }
    }
  }
</script>

<template>
  <div class="recipes ">
    <div class="container">
      <div class="mt-5">
        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="font-weight-bold">
              Search ingredient
            </label>
            <div class="input-group">
              <input
                @keyup.enter="selectIngredient"
                v-model="ingredientName"
                type="text"
                class="form-control"
              >
              <div class="input-group-append">
                <button
                  @click="selectIngredient"
                  :disabled="!ingredientName"
                  class="btn btn-outline-secondary"
                >
                  Add
                </button>
              </div>
            </div>
          </div>
          <div class="form-group col-md-6">
            <label class="font-weight-bold">Number of peoples</label>
            <select
              v-model="peopleQuantity"
              class="form-control"
            >
              <option
                v-for="number in 6"
                :value="number"
              >
                {{ number }}
              </option>
            </select>
          </div>
        </div>
      </div>
      <template v-if="selectedIngredients.length > 0">
       <p class="font-weight-bold">
        Selected ingredients:
        </p>
        <ul class="list-inline">
          <li
            v-for="ingredient in selectedIngredients"
            class="list-inline-item"
          >
            <span class="badge badge-info">
              {{ ingredient }}
              <span
                @click="removeIngredient(ingredient)"
                title="remove"
                class="remove"
              >
              x
            </span>
            </span>
          </li>
        </ul>
      </template>
      <button
        @click="fetchMatchingRecipes"
        :disabled="canSeachRecipes()"
        class="btn btn-success"
      >
        Search recipes
      </button>
      <div
        v-if="displayRecipes"
        class="mt-3"
      >
        <p class="font-weight-bold">
          Recipes:
        </p>
        <div v-if="isFetchingRecipes">
          Fetching recipes
        </div>
        <template v-else>
          <span v-if="recipes.length === 0">
            No Matching recipes for
            {{ peopleQuantity }} gest(s)
            containing your selected ingredients
          </span>
          <template v-else>
            <ul
              @scroll="onRecipesScroll"
              class="list-unstyled recipes-list"
            >
              <li
                v-for="recipe in recipes"
                class="card bg-light mb-3"
              >
                <div class="card-header d-flex justify-content-between">
                 <span>
                    Cook time:
                   {{ recipe.cook_time }}
                 </span>
                 <span class="font-weight-bold">
                   {{ recipe.name }}
                 </span>
                 <span>
                   Difficulty:
                   {{ recipe.difficulty }}
                 </span>
                </div>
                <div class="card-body">
                  <h5 class="card-title">Ingredients</h5>
                  <ul>
                    <li v-for="ingredient in recipe.ingredients">
                      <span :class="{'font-weight-bold': selectedIngredientsHas(ingredient.name) }">
                         {{ ingredient.name }}
                      </span>
                    </li>
                  </ul>
                </div>
              </li>
            </ul>
          </template>
        </template>
      </div>
    </div>
  </div>
</template>
