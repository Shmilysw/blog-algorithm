<template>
    <header>
        <span class="brand"></span>
        <span class="container">
            <span class="menu">
                <ul>
                    <li v-for="m in menu">
                        <a :href="base + m.url">
                            <span>
                                <i :class="['fa', m.icon]"></i>
                                {{ m.name }}
                            </span>
                        </a>
                    </li>
                </ul>
            </span>
        </span>
        <!-- <span class="other">
            <a class="search">
                <i class="fa fa-search"></i>
            </a>
        </span> -->
        <div class="search-box">
            <a class="search">
                <input v-model="input" @onclick="current()" @keyup.enter.native="keyDown()">
            </a>
        </div>
    </header>
</template>

<script setup lang="ts">
import { useData } from 'vitepress'
import { ref } from 'vue'
// import setTag from './Tag.vue'
const input = ref('')
const current = () => {
    console.log(input.value);
    // new setTag(input.value);
}
// console.log(input)
//点击回车键触发事件
const keyDown = () => {
    current()
}
const base = useData().site.value.base
interface MenuItem { icon: string, name: string, url: string }
const menu: MenuItem[] = [
    { icon: 'fa-home', name: '首页', url: '' },
    { icon: 'fa-tag', name: '标签', url: 'tags/' },
    { icon: 'fa-leaf', name: '关于', url: 'readme.html' }
]
</script>

<style lang="scss">
.search-box {
    display: inline-block;
    position: relative;
    margin-right: 1rem;

    input {
        cursor: text;
        width: 10rem;
        height: 2rem;
        color: var(--textColor);
        display: inline-block;
        border: 1px solid var(--borderColor, #ccc);
        border-radius: 2rem;
        font-size: .9rem;
        line-height: 2rem;
        padding: 0 0.5rem 0 2rem;
        outline: none;
        transition: width .2s ease;
        background: url(https://xugaoyi.com/assets/img/search.83621669.svg) 0.6rem 0.5rem no-repeat;
        background-size: 1rem;
    }
}

input {
    background-color: transparent;
    color: var(--textColor);
    border: 1px solid var(--borderColor, #ccc);
}

header {
    position: fixed;
    top: 0;
    width: 100%;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    // rgba(255, 255, 255, 0.9)
    background: rgba(255, 255, 255, 0.6);
    z-index: 100;

    .brand {
        justify-self: left;
        padding-left: 8px;
    }

    .container {
        position: absolute;
        left: 50%;
        translate: -50%;
    }

    .other {
        justify-self: right;
        padding-right: 8px;
    }

    .menu {
        ul {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        li {
            margin: 0 12px;
            display: inline;
        }
    }

    a {
        color: var(--color-gray);
        transition: color 0.2s ease-out;

        &:hover {
            color: var(--color-accent);
        }
    }
}
</style>
