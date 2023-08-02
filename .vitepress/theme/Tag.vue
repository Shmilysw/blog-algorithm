<template>
    <div class="tag">
        <div class="article">
            <a :class="['item', { 'active': active === tag }]" href="#" v-for="(_, tag) in tagData" @click="setTag(tag)">
                <span>{{ tag }}</span>
            </a>
            <div class="search-box">
                <a class="search">
                    <input v-model="input" placeholder="请输入标签" @onclick="current()" @keyup.enter.native="keyDown()">
                </a>
            </div>
        </div>
        <BlogList :posts="active ? tagData[active] : []" :click="setTag" />
    </div>
</template>

<script setup lang="ts">
import BlogList from './BlogList.vue'
import { data as posts, type PostData } from '../posts.data'
import { ref, onMounted } from 'vue'
// 搜索功能
// import input from './Header.vue'
const input = ref('')
const current = () => {
    // console.log(input.value);
    setTag(input.value);
    // new setTag(input.value);
}
// console.log(input)
//点击回车键触发事件
const keyDown = () => {
    current()
}

const active = ref<string | null>(null)
const tagData: Record<string, PostData[]> = {}
const setTag = (tag: string) => {
    active.value = tag
    history.replaceState(null, document.title, '?q=' + tag)
}
for (const post of posts) {
    if (!post.tags) continue
    for (const tag of post.tags) {
        if (!tagData[tag]) tagData[tag] = []
        tagData[tag].push(post)
    }
}

onMounted(() => {
    setTag('算法');
    // console.log(input.value);
    active.value = new URLSearchParams(location.search).get('q')
})
</script>

<style lang="scss" scoped>
.search-box {
    display: inline-block;
    position: relative;
    margin-left: 3px;

    // margin-right: 1rem;
    input {
        cursor: text;
        width: 8rem;
        height: 2rem;
        color: var(--textColor);
        display: inline-block;
        border: 1px solid var(--borderColor, #ccc);
        border-radius: 2rem;
        font-size: .9rem;
        line-height: 2.4rem;
        padding: 0 0.5rem 0 2rem;
        outline: none;
        transition: width .2s ease;
        background: url(https://xugaoyi.com/assets/img/search.83621669.svg) 0.6rem 0.5rem no-repeat;
        background-size: 1rem;
    }
}

.tag {
    margin-top: 64px;

    .item {
        display: inline-block;
        padding: 6px 12px;
        margin: 4px;
        border-radius: 40px;
        color: var(--color-gray);
        border: 1px solid var(--color-border);
        transition: all 0.2s ease-out;
        background-color: #fff;

        &:hover,
        &.active {
            color: var(--color-accent);
            border-color: var(--color-accent);
        }
    }
}
</style>
