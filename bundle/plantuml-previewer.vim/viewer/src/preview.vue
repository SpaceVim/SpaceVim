<template>
  <div class="body">
    <div class="tools">
      <a title="Double click" @click="boxReset"><img src="./icons/home.svg"></a>
      <a title="Mouse wheel" @click="zoom(-100)"><img src="./icons/zoom-in.svg"></a>
      <a title="Mouse wheel" @click="zoom(100)"><img src="./icons/zoom-out.svg"></a>
    </div>
    <div class="wrapper" ref="wrapper" @dblclick="boxReset">
      <div
        class="box"
        :style="{width: img.width + 'px', height: img.height + 'px'}"
        :data-center="`left: ${relativeCenter.left}, top: ${relativeCenter.top}`"
        ref="box">
        <img
        v-show="url"
        :src="url"
        @load="() => $emit('loadedImage')">
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.body {
  width: 100%;
  height: 100%;
  position: relative;
}
.tools {
  position: absolute;
  right: 10px;
  top: 10px;
  display: flex;
  flex-direction: column;
  z-index: 1000;
  a {
    cursor: pointer;
    display: block;
    width: 30px;
    height: 30px;
    img {
      width: 30px;
      height: 30px;
    }
  }
}
.wrapper {
  flex: 1;
  width: 100%;
  height: 100%;
  position: relative;
  top: 0;
  left: 0;
  overflow: hidden;
  background: #ccc;
}
.box {
  position: absolute;
  img {
    width: 100%;
    height: 100%;
  }
  cursor: move;
}
</style>

<script>
import {addWheelListener, removeWheelListener} from 'wheel'
import Dragger from 'draggabilly'

const updateJsPath = '../tmp.js'
const diagramUrl = '../tmp.svg'
const $tmpImage = new Image()

export default {
  data() {
    return {
      img: {
        realWidth: null,
        realHeight: null,
        width: null,
        height: null,
        whRate: null,
      },
      relativeCenter: {
        left: null,
        top: null,
      },
      lastTimestamp: null,
      needReset: true,
      diagramUrl,
      url: null,
    }
  },
  methods: {
    boxReset() {
      const $wrapper = this.$refs.wrapper
      if ($wrapper.clientWidth / $wrapper.clientHeight > this.img.whRate) {
        this.boxResize({height: $wrapper.clientHeight})
      } else {
        this.boxResize({width: $wrapper.clientWidth})
      }
      this.boxCenter()
    },
    boxResize({width = null, height = null} = {}) {
      const $box = this.$refs.box
      if (width) {
        this.img.width = width
        this.img.height = width / this.img.whRate
      } else if (height) {
        this.img.height = height
        this.img.width = height * this.img.whRate
      }
    },
    boxCenter({top = 0, left = 0} = {}) {
      const $wrapper = this.$refs.wrapper
      const $box = this.$refs.box
      this.relativeCenter.left = left
      this.relativeCenter.top = top
      left = $wrapper.clientWidth/2 - (left * this.img.width) - this.img.width/2
      top = $wrapper.clientHeight/2 - (top * this.img.height) - this.img.height/2
      $box.style.left = left + 'px'
      $box.style.top = top + 'px'
    },
    bindEvent() {
      const $wrapper = this.$refs.wrapper
      const $box = this.$refs.box
      const dragger = new Dragger($box)
      dragger.on('dragEnd', event => {
        let {top, left} = $box.style
        top = parseFloat(top)
        left = parseFloat(left)

        this.relativeCenter.left = ($wrapper.clientWidth/2 - (left + this.img.width/2)) / this.img.width
        this.relativeCenter.top = ($wrapper.clientHeight/2 - (top + this.img.height/2)) / this.img.height
      })
      addWheelListener($wrapper, e => {
        e.preventDefault()
        this.zoom(e.deltaY)
      })

      $tmpImage.addEventListener('error', (error) => {
        console.error(error)
        this.needReset = true
      })
      $tmpImage.addEventListener('load', () => {
        this.url = $tmpImage.src
        this.img.realWidth = $tmpImage.width
        this.img.realHeight = $tmpImage.height
        const whRate = $tmpImage.width / $tmpImage.height
        if (this.img.whRate !== whRate) {
          this.img.height = this.img.width / whRate
          this.img.whRate = whRate
        }
        if (this.needReset) {
          this.needReset = false
          this.boxReset()
        }
      })
    },
    zoom(delta) {
      const width = this.img.width - delta * this.img.width / 1000
      if (width > 100) {
        const {top, left} = this.relativeCenter
        this.boxResize({width})
        this.boxCenter({top, left})
      }
    },
    reloadImage() {
      $tmpImage.src = this.diagramUrl + '?t=' + Date.now()
    },
    reloadUpdateJs() {
      const head = document.getElementsByTagName('head')[0]
      const script = document.createElement('script')
      const removeScript = () => {
        setTimeout(() => {
          head.removeChild(script)
        }, 200)
      }
      script.type = 'text/javascript'
      script.addEventListener('error', removeScript)
      script.addEventListener('load', removeScript)
      script.src = updateJsPath + '?t=' + Date.now()
      head.appendChild(script)
    },
  },
  mounted() {
    this.bindEvent()
    this.reloadImage()
    window.updateDiagramURL = (timestamp) => {
      if (timestamp !== this.lastTimestamp) {
        this.lastTimestamp = timestamp
        this.reloadImage()
      }
    }
    setInterval(() => {
      this.reloadUpdateJs()
    }, 1000)
  },
}
</script>
