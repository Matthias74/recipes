<script>

  const MATCHING_INGREDIENTS_HEIGHT = 125
  const RECIPES_LIST_HEIGHT = 300

  export default {
    data() {
      return {
        peopleQuantity: 1,
        ingredientQuery: null,
        selectedIngredients: [],
        matchingIngredients: [],
        isFetchingIngredients: false,
        recipes: [],
        isFetchingRecipes: false,
        displayRecipes: false,
        strictSelection: false,
        pagination: {
          recipes: {
            totalPages: null,
            currentPage: 1
          },
          ingredients: {
            totalPages: null,
            currentPage: 1
          }
        }
      }
    },

    methods: {
      selectIngredient(ingredient) {
        this.selectedIngredients.push(ingredient)
        this.resetRecipes()
      },

      removeIngredient(ingredient) {
        const ingredients = this.selectedIngredients.filter((selectedIngr) => selectedIngr.id !== ingredient.id)
        this.selectedIngredients = ingredients
        this.resetRecipes()
      },

      fetchMatchingIngredients() {
        $.ajax({
          mehtod: "GET",
          url: "/ingredients",
          data: {
            query: this.ingredientQuery,
            current_page: this.pagination.ingredients.currentPage
          },
          success: (data) => {
            this.pagination.ingredients.currentPage += 1
            this.pagination.ingredients.totalPages = data.total_pages
            this.matchingIngredients = this.matchingIngredients.concat(data.ingredients)
          }
        })
      },

      fetchMatchingRecipes() {
        const data = {
          people_quantity: this.peopleQuantity,
          ingredient_ids: this.selectedIngredients.map((ingredient) => ingredient.id ),
          current_page: this.pagination.recipes.currentPage
        }

        if(this.strictSelection) {
          Object.assign(data, { strict: true })
        } else {
          if(Object.keys(data).includes("strict")) {
            delete data["strict"]
          }
        }

        $.ajax({
          method: "GET",
          url: "/recipes",
          data: data,
          success: (data) => {
            this.displayRecipes = true
            this.pagination.recipes.currentPage += 1
            this.pagination.recipes.totalPages = data.total_pages
            this.recipes = this.recipes.concat(data.recipes)
          }
        })
      },

      onRecipesScroll(event) {
        if(
            event.target.scrollHeight - event.target.scrollTop === RECIPES_LIST_HEIGHT &&
            this.pagination.recipes.currentPage < this.pagination.recipes.totalPages
          ) {
          this.fetchMatchingRecipes()
        }
      },

      onIngredientsScroll(event) {
        if(
            event.target.scrollHeight - event.target.scrollTop === MATCHING_INGREDIENTS_HEIGHT &&
            this.pagination.ingredients.currentPage < this.pagination.ingredients.totalPages
          ) {
          this.fetchMatchingIngredients()
        }
      },

      selectedIngredientsHas(ingredient) {
        return !!this.selectedIngredients.find((selectedIngr) => {
          return selectedIngr.name.split(" ").every((word) => {
            return ingredient.includes(word)
          })
        })
      },

      canSeachRecipes() {
        if(this.strictSelection) {
          return this.selectedIngredients.length < 2 || this.isFetchingRecipes
        } else {
          return this.selectedIngredients.length === 0 || this.isFetchingRecipes
        }
      },

      resetRecipes() {
        this.displayRecipes = false
        this.recipes = []
        this.pagination.recipes.currentPage = 1
        this.pagination.recipes.totalPages = null
      }
    },

    watch: {
      ingredientQuery: function() {
        if(!["", null].includes(this.ingredientQuery)){
          this.matchingIngredients = []
          this.pagination.ingredients.currentPage = 1
          this.pagination.ingredients.totalPages = null
          this.fetchMatchingIngredients()
        }
      },
      strictSelection: function() {
        this.resetRecipes()
      },

      peopleQuantity: function() {
        this.resetRecipes()
      }
    }
  }
</script>

<template>
  <div class="recipes ">
    <div class="container">
      <form class="mt-5">
        <div class="form-row">
          <div class="form-group col-md-6">
            <label class="font-weight-bold">
              Search ingredient
            </label>
            <input
              v-model="ingredientQuery"
              type="text"
              class="form-control"
            >
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
      </form>
      <div
        v-if="ingredientQuery && !isFetchingIngredients"
        class="row"
      >
        <div class="col-md-6 text-left">
          <p class="font-weight-bold">
           Matching ingredients:
         </p>
          <ul
            v-if="matchingIngredients.length > 0"
            @scroll="onIngredientsScroll"
            class="list-unstyled matching-ingredient-list"
          >
            <li
              v-for="ingredient in matchingIngredients"
              @click="selectIngredient(ingredient)"
              class="ingredient px-2"
            >
              {{ ingredient.name }}
            </li>
          </ul>
          <div
            v-else
            class="pb-3"
          >
            No matching ingredients for
            {{ ingredientQuery }}
          </div>
        </div>
        <div class="col-md-6 text-left">
          <div class="form-check">
            <input class="form-check-input" type="radio" :value="true" v-model="strictSelection">
            <label class="form-check-label">
             Select recipes which only contains selected ingredients
            </label>
          </div>
          <div class="form-check">
            <input class="form-check-input" type="radio" :value="false" v-model="strictSelection">
            <label class="form-check-label">
              Select recipes which contains selected ingredients and others
            </label>
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
              {{ ingredient.name }}
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
      <p
        v-if="strictSelection && selectedIngredients.length < 2"
        class="text-danger"
      >
        You must select at least 2 ingredients
      </p>
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

                        <span :class="{'font-weight-bold': selectedIngredientsHas(ingredient) }">
                          {{ ingredient }}
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
