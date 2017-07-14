<template>
  <div id="app">
      <div id="micropost_feed_outer">
          <ul>
              <li v-for="item in microposts">
                  {{ item.content }}
                  {{ item.created_at }}
              </li>
          </ul>
      </div>
  </div>
</template>

<script>
export default {
    data: {
        microposts: [{
            content: "sample",
            created_at: "sample1"
        }]
    }
}
</script>

<style scoped>
</style>
