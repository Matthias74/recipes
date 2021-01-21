import Vue from 'vue/dist/vue.esm.js'
import Recipes from '../recipes/recipes.vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#app',
    components: {
      recipes: Recipes
    }
  });
});
