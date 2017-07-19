<template>
    <div id="root">
        <h1>Hello App!</h1>
        <p>
        <router-link to="/user">Go to feed</router-link>
        </p>
        <!-- ルートアウトレット -->
        <!-- ルートとマッチしたコンポーネントがここへ描画されます -->
        <router-view></router-view>
    </div>
</template>
