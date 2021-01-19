import Vue from 'vue'
import Recipes from '../recipes/recipes.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(Recipes)
  }).$mount()
  document.body.appendChild(app.$el)
})
