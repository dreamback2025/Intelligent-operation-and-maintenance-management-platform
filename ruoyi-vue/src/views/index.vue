<template>
  <div class="app-container">
    <div class="home-page">
      <div class="home-left">
        <div style="margin-top: 0px">
          <div class="header-default">
            时段发电占比
            <span>单位:kWh</span>
          </div>
          <div class="date-wrap" style="width: 120px">
            <div
              :class="peaksTimeType == 'month' ? 'switch-date-active' : 'switch-date'"
              @click="switchPeaksDate('month')"
            >
              本月
            </div>
            <div :class="peaksTimeType == 'day' ? 'switch-date-active' : 'switch-date'" @click="switchPeaksDate('day')">
              本日
            </div>
          </div>
          <div ref="ringChartRef" style="height: 280px; margin-top: 32px"></div>
        </div>
        <div style="margin-top: 16px">
          <div class="header-default">
            <span>当年发电效率排行</span>
          </div>
          <div class="site-rank-list">
            <div class="flex-start rank-item rank-item-zero">
              <div style="width: 20%">排名</div>
              <div style="width: 40%">电站名称</div>
              <div style="width: 40%">当年发电效率</div>
            </div>
            <div v-for="(item, index) in rankList" :key="index" class="flex-start rank-item">
              <div style="width: 20%">
                <img v-if="index < 3" :src="getImageUrl(`no-${index + 1}`)" alt="" />
                <div v-else>{{ index + 1 }}</div>
              </div>
              <div @click="toSite(item)" title="查看详情" style="width: 40%; cursor: pointer" class="site">
                {{ item.powerStationName }}
              </div>
              <div style="width: 40%">{{ item.sumValue }}</div>
            </div>
          </div>
        </div>
      </div>
      <div class="home-center">
        <div class="sum-wrapper">
          <div
            v-for="(item, index) in statisticList"
            class="sum-item"
            :class="{ bg1: index === 1 || index === 3, bg2: index === 2 }"
          >
            <div class="img">
              <img :src="getImageUrl(`icon-${index + 1}`)" alt="" />
            </div>
            <div>
              <div class="value">{{ item.value }}</div>
              <div class="label">{{ item.label }}</div>
            </div>
          </div>
        </div>
        <div class="map-wrap">
          <div ref="chinaMapRef" :style="`height: ${containerHeight - 390}px; width: 100%`"></div>
        </div>
        <div style="margin-top: 12px">
          <div class="header-default">
            全厂发电量环比
            <span>单位:kWh</span>
          </div>
          <div class="date-wrap loop-date-wrap" style="width: 180px">
            <div class="loop-switch-indicator" :style="{ transform: `translateX(${loopSwitchOffset}px)` }"></div>
            <div :class="loopTimeType == 'year' ? 'switch-date-active switch-label' : 'switch-date switch-label'" @click="switchLoopDate('year')">
              本年
            </div>
            <div
              :class="loopTimeType == 'month' ? 'switch-date-active switch-label' : 'switch-date switch-label'"
              @click="switchLoopDate('month')"
            >
              本月
            </div>
            <div :class="loopTimeType == 'day' ? 'switch-date-active switch-label' : 'switch-date switch-label'" @click="switchLoopDate('day')">
              本日
            </div>
          </div>
          <div ref="loopChartRef" style="height: 300px; width: 100%; margin-top: 24px"></div>
        </div>
      </div>
      <div class="home-right">
        <div>
          <div class="header-default">
            年发电量
            <span>单位:kWh</span>
          </div>
          <div ref="lineChartRef" style="height: 280px"></div>
        </div>
        <div style="margin-top: 16px">
          <div class="header-default">今日报警概览</div>
          <div class="alarm-wrapper">
            <div class="flex-start" style="height: 100px; cursor: pointer" @click="toAlarm">
              <img class="total-img" src="@/assets/images/icon-alarm.png" alt="" />
              <div class="total-view">
                <div class="value">{{ alarmInfo.todayAlarmCount }}</div>
                <div class="label">全部报警</div>
              </div>
            </div>
            <div class="alarm-list flex-start">
              <div class="item">
                <div class="value">{{ alarmInfo.todayUnprocessed }}</div>
                <div class="label">未处理</div>
              </div>
              <div class="item">
                <div class="value" style="color: #26a978">{{ alarmInfo.todayProcessed }}</div>
                <div class="label">已处理</div>
              </div>
            </div>
            <div class="alarm-list flex-start">
              <div class="item">
                <div class="value" style="color: #d22041">{{ alarmInfo.todayLevel1 }}</div>
                <div class="label">事故</div>
              </div>
              <div class="item">
                <div class="value" style="color: #deb650">{{ alarmInfo.todayLevel2 }}</div>
                <div class="label">严重</div>
              </div>
              <div class="item">
                <div class="value" style="color: #20d2a3">{{ alarmInfo.todayLevel3 }}</div>
                <div class="label">普通</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup name="Index">
import { formatDate, formatDateObj, formatChartTime } from "@/utils/index"
import { getImageUrl } from "@/utils/index"
import * as echarts from "echarts"
import chinaJson from "@/assets/map/china.json"
import { ref, computed, nextTick, onMounted, onBeforeUnmount, onUnmounted, onActivated, onDeactivated, watch } from "vue"
import useAppStore from "@/store/modules/app"
// import { useRouter } from "vue-router"
import { resize, destroyListener } from "@/utils/resize"
import {
  getSiteRank,
  getPeriodGenerationPercentage,
  getLoopCompareList,
  getHomePowerStationInfo,
  listHomeAlarm,
  homepageGeneration,
} from "@/api/analysis/home"

const router = useRouter()
const { proxy } = getCurrentInstance()
const containerHeight = ref(window.innerHeight - 90)
echarts.registerMap("china", chinaJson)

// echarts-ring
const ringChartRef = ref(null)
const ringChartData = ref([])
let echartsInstance = null
function drawRingChart() {
  nextTick(() => {
    echartsInstance = echarts.init(ringChartRef.value, "macarons")
    echartsInstance.setOption({
      tooltip: {
        trigger: "item",
        formatter: "{b}: {c} / {d}%",
      },
      legend: {
        top: 16,
        bottom: 16,
        left: "center",
      },
      series: [
        {
          name: "",
          type: "pie",
          top: 52,
          radius: ["30%", "60%"],
          itemStyle: {
            borderRadius: 4,
            borderColor: "#fff",
            borderWidth: 2,
          },
          label: {
            // show: true,
            // position: "center",
            formatter: "{b}\n{c}",
          },
          color: ["#ff6f61", "#f1c84b", "#47cda7", "#3bbd94", "#2ea67f"],
          data: ringChartData.value,
        },
      ],
    })
  })
}

// echarts-line -年发电量
const lineChartRef = ref(null)
const lineTime = ref([])
const lineYData = ref([])
const loopTimeType = ref("month")
const loopSwitchOffset = computed(() => {
  if (loopTimeType.value === "year") return 0
  if (loopTimeType.value === "month") return 60
  return 120
})
let lineInstance = null
function drawLineChart() {
  nextTick(() => {
    lineInstance = echarts.init(lineChartRef.value, "macarons")
    lineInstance.setOption({
      title: {
        text: "",
      },
      tooltip: {
        trigger: "axis",
      },
      legend: false,
      grid: {
        top: 20,
        left: "1%",
        right: 16,
        bottom: 8,
        containLabel: true,
      },
      // toolbox: {
      //   feature: {
      //     saveAsImage: {},
      //     dataView: {},
      //     restore: {},
      //     magicType: {
      //       type: ["line", "bar", "stack"],
      //     },
      //   },
      // },
      xAxis: {
        type: "category",
        // boundaryGap: false,
        data: lineTime.value,
      },
      yAxis: {
        type: "value",
      },
      series: [
        {
          name: "发电量",
          type: "line",
          smooth: true,
          label: {
            show: true,
            // position: "top",
          },
          // barWidth: 20,
          // stack: "Total",
          color: "#28b487",
          data: lineYData.value,
        },
      ],
    })
  })
}

// echart-环比
function switchLoopDate(type) {
  loopTimeType.value = type
  getLoopData()
}
function getLoopData() {
  let dateObj = formatDateObj(new Date())
  let queryTime = ""
  queryTime = dateObj.year + "-" + dateObj.month + "-" + dateObj.day
  // if (peaksTimeType.value == "day") {
  //   queryTime = dateObj.year + "-" + dateObj.month + "-" + dateObj.day
  // } else if (peaksTimeType.value == "month") {
  //   queryTime = dateObj.year + "-" + dateObj.month
  // } else {
  //   queryTime = dateObj.year
  // }
  getLoopCompareList({
    queryTime,
    timeType: loopTimeType.value.toUpperCase(),
  }).then((res) => {
    loopData.value = res.data.map((item) => {
      return {
        time: formatChartTime(loopTimeType.value, item.currentTime),
        value: item.currentValue,
        oldValue: item.contrastValues,
        ratio: item.ratio,
      }
    })
    drawLoopChart()
  })
}
const loopChartRef = ref(null)
let loopChartInstance = null
const loopData = ref([])
function drawLoopChart() {
  loopChartInstance = echarts.init(loopChartRef.value, "macarons")
  // 监听 echarts 的 finished 事件
  let resizeObserverAdded = false
  loopChartInstance.on("finished", function () {
    if (!resizeObserverAdded) {
      resize(loopChartInstance, loopChartRef.value)
    }
    resizeObserverAdded = true
  })
  let option = {
    title: {},
    tooltip: {
      trigger: "axis",
      axisPointer: {
        type: "shadow",
        label: {
          show: true,
        },
      },
    },
    calculable: true,
    legend: {
      data: ["本期值", "同期值", `环比值`],
      itemGap: 5,
      // align: "center",
      top: 4,
    },
    grid: {
      top: 36,
      left: "1%",
      right: "1%",
      bottom: 16,
      containLabel: true,
    },
    xAxis: [
      {
        name: "",
        type: "category",
        data: loopData.value.map((item) => {
          return item.time
        }),
      },
    ],
    yAxis: [
      {
        type: "value",
        name: "",
        axisLabel: {
          formatter: function (a) {
            return +a
          },
          // rotate: 25, // 倾斜
        },
      },
      {
        type: "value",
        name: "",
        position: "right",
        alignTicks: true,
        // min: 0,
        // max: 100,
        // interval: 20,
        axisLabel: {
          // formatter: "{value} %",
          formatter: function (val) {
            val = val.toFixed(0)
            return val + "%"
          },
        },
      },
    ],
    series: [
      {
        name: "本期值",
        type: "bar",
        smooth: true,
        color: "#46c7a3",
        data: loopData.value.map((item) => {
          return item.value
        }),
      },
      {
        name: "同期值",
        type: "bar",
        smooth: true,
        color: "#eaeaea",
        data: loopData.value.map((item) => {
          return item.oldValue
        }),
      },
      {
        name: `环比值`,
        type: "line",
        smooth: true,
        yAxisIndex: 1,
        color: "#2aa67d",
        tooltip: {
          valueFormatter: function (value) {
            return value + "%"
          },
        },
        data: loopData.value.map((item) => {
          return item.ratio
        }),
      },
    ],
  }
  loopChartInstance.setOption(option)
  loopChartInstance.resize()
}

// data
const rankList = ref([])
const chinaMapRef = ref(null)
const mapMarkerList = ref([])
let chinaMapInstance = null

function drawChinaMap() {
  nextTick(() => {
    if (!chinaMapRef.value) {
      return
    }
    if (!chinaMapInstance) {
      chinaMapInstance = echarts.init(chinaMapRef.value, "macarons")
      chinaMapInstance.on("click", (params) => {
        if (params?.data?.id) {
          router.push("/realTime/site?site=" + params.data.id)
        }
      })
    }

    const data = mapMarkerList.value.map((item) => {
      return {
        name: item.name,
        value: [item.position[0], item.position[1], Number(item.value) || 0],
        id: item.id,
      }
    })

    chinaMapInstance.setOption({
      tooltip: {
        trigger: "item",
        formatter: (params) => {
          if (Array.isArray(params.value)) {
            return `${params.name}<br/>当年发电效率：${params.value[2]}`
          }
          return params.name
        },
      },
      geo: {
        map: "china",
        roam: false,
        zoom: 1.38,
        layoutCenter: ["50%", "54%"],
        layoutSize: "140%",
        label: {
          show: false,
        },
        itemStyle: {
          areaColor: "#eaf8f1",
          borderColor: "#9dd8c0",
        },
        emphasis: {
          itemStyle: {
            areaColor: "#d6f2e4",
          },
        },
      },
      series: [
        {
          name: "电站",
          type: "scatter",
          coordinateSystem: "geo",
          symbolSize: 14,
          itemStyle: {
            color: "#2dbb83",
            borderColor: "#ffffff",
            borderWidth: 2,
          },
          label: {
            show: false,
            formatter: "{b}",
            position: "right",
            color: "#2a9a70",
            fontSize: 12,
          },
          emphasis: {
            label: {
              show: true,
            },
          },
          data,
        },
      ],
    })
    chinaMapInstance.resize()
  })
}
const statisticList = ref([
  { label: "当年累计发电量", value: "0" },
  { label: "当日发电量", value: "0" },
  { label: "当日发电收益", value: "0" },
  { label: "总装机容量", value: "0" },
  // { label: "当前发电功率", value: "0.23kW" },
  // { label: "累计发电量", value: "0" },
  // { label: "累计发电收益", value: "0" },
  { label: "累计CO2减排量", value: "0" },
])
const alarmInfo = ref({})

function formatDisplayValue(value, defaultValue = "0") {
  if (value === null || value === undefined) {
    return defaultValue
  }
  const str = String(value).trim()
  if (!str) {
    return defaultValue
  }
  return str
}

function getData() {
  // 排名-map
  getSiteRank().then((res) => {
    rankList.value = res.data
    mapMarkerList.value = res.data
      .filter((f) => {
        return f.lon && f.lat
      })
      .map((item) => {
        return {
          name: item.powerStationName,
          position: [item.lon, item.lat],
          echartsPosition: [item.lon, item.lat],
          value: item.sumValue,
          id: item.powerStationId,
        }
      })
    drawChinaMap()
  })
  // 统计6项
  getHomePowerStationInfo().then((res) => {
    statisticList.value[1].value = formatDisplayValue(res.data.cumulativeDay, "0kWh")
    statisticList.value[2].value = formatDisplayValue(res.data.earningsDay, "0元")
    statisticList.value[3].value = formatDisplayValue(res.data.installedCapacity, "0MW")
    statisticList.value[0].value = formatDisplayValue(res.data.cumulativeYear, "0kWh")
    statisticList.value[4].value = formatDisplayValue(res.data.carbonEmissions, "0kg")
  })
  // alarm
  listHomeAlarm({}).then((res) => {
    alarmInfo.value = res.data
  })
  // 峰平谷
  getPeaksData()
  // 年发电量
  homepageGeneration({ queryTime: formatDate(new Date()).substring(0, 10), timeType: "YEAR" }).then((res) => {
    lineYData.value = res.data.map((item) => {
      return item.value
    })
    lineTime.value = res.data.map((item) => {
      return formatChartTime("year", item.time)
    })
    drawLineChart()
  })
}

// 峰平谷
const peaksTimeType = ref("month")
function switchPeaksDate(type) {
  peaksTimeType.value = type
  getPeaksData()
}
function getPeaksData() {
  let dateObj = formatDateObj(new Date())
  let queryTime = ""
  if (peaksTimeType.value == "day") {
    queryTime = dateObj.year + "-" + dateObj.month + "-" + dateObj.day
  } else if (peaksTimeType.value == "month") {
    queryTime = dateObj.year + "-" + dateObj.month
  }
  let params = {
    queryTime,
    timeType: peaksTimeType.value.toUpperCase(),
  }
  getPeriodGenerationPercentage(params).then((res) => {
    ringChartData.value = res.data
    drawRingChart()
  })
}
function toAlarm() {
  router.push("/alarm")
}

function toSite(item) {
  router.push("/realTime/site?site=" + item.powerStationId)
}

onMounted(() => {
  getData()
  getLoopData()
})

onActivated(() => resize(loopChartInstance, loopChartRef.value))

onDeactivated(() => destroyListener(loopChartInstance, loopChartRef.value))

onBeforeUnmount(() => {
  if (chinaMapInstance) {
    chinaMapInstance.dispose()
    chinaMapInstance = null
  }
  if (!loopChartInstance) {
    return
  }
  loopChartInstance.dispose() // 销毁图表
  loopChartInstance = null
})
</script>

<style scoped lang="scss">
.home-page {
  display: flex;
  justify-content: space-between;
  .home-left {
    background: rgba(23, 150, 104, 0.06);
    width: 320px;
    min-height: 100%;
  }
  .home-right {
    background: rgba(23, 150, 104, 0.045);
    width: 360px;
  }
  .home-center {
    flex: 1;
    margin: 0 12px;
  }
  .header-default {
    height: 40px;
    width: 100%;
    color: #fff;
    padding: 0 12px;
    line-height: 40px;
    background-image: linear-gradient(315deg, #3fd6a7 0, #198f68 100%);
    border-radius: 2px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .date-wrap {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    background: #eaeaea;
    border-radius: 12px;
    height: 26px;
    float: right;
    margin-top: 12px;
    cursor: pointer;
    .switch-date,
    .switch-date-active {
      // font-size: 30px;
      color: #333;
      width: 60px;
      height: 26px;
      line-height: 26px;
      text-align: center;
    }
    .switch-date-active {
      // background: center center #4a54ff;
      // background-image: linear-gradient(315deg, #6772ff 0, #00f9e5 100%);
      // background-size: 104% 104%;
      background-color: #26a978;
      color: #fff;
      font-weight: 500;
      border-radius: 24px;
    }
  }
}
.sum-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  .sum-item {
    width: 19%;
    // margin-right: 12px;
    background: #d4ecdf;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    padding: 10px 8px;
    background: center center #1b966f;
    background-image: linear-gradient(315deg, #42cea1 0, #1f8f69 100%);
    // background-size: 104% 104%;
    border-radius: 6px;
    color: #fff;
    height: 84px;
    margin-bottom: 10px;
    box-sizing: border-box;
    .img {
      img {
        width: 38px;
        margin-right: 8px;
      }
    }
    > div:last-child {
      min-width: 0;
    }
    .value {
      font-size: 18px;
      font-weight: 600;
      margin-bottom: 2px;
      line-height: 1.2;
      white-space: normal;
      word-break: break-all;
    }
    .label {
      line-height: 1.2;
      font-size: 11px;
      white-space: normal;
      word-break: break-all;
    }
  }
  .bg1 {
    background: center center #2aa67d;
    background-image: linear-gradient(315deg, #4dcba5 0, #2a9e76 100%);
  }
  .bg2 {
    background: center center #238b67;
    background-image: linear-gradient(315deg, #39bf96 0, #1e7f5e 100%);
  }
}

.loop-date-wrap {
  position: relative;
  overflow: hidden;
  .loop-switch-indicator {
    position: absolute;
    left: 0;
    top: 0;
    width: 60px;
    height: 26px;
    background-color: #26a978;
    border-radius: 24px;
    transition: transform 0.2s ease;
    z-index: 1;
  }
  .switch-label {
    z-index: 2;
  }
  .switch-date-active {
    background-color: transparent !important;
  }
}

.alarm-wrapper {
  .total-img {
    width: 70px;
    margin-left: 16px;
    margin-right: 8px;
  }
  .total-view {
    .value {
      color: #f55957;
      font-size: 24px;
      font-weight: 600;
      letter-spacing: 1px;
      margin-bottom: 4px;
    }
    .label {
      color: #333;
    }
  }

  .alarm-list {
    margin: 12px 0 32px;
    .item {
      width: 100px;
      text-align: center;
    }
    .value {
      color: #f67d7b;
      // color: #f67d7b;
      font-size: 22px;
      font-weight: 600;
      letter-spacing: 1px;
      margin-bottom: 2px;
    }
    .label {
      color: #666;
      font-size: 14px;
    }
  }
}

.site-rank-list {
  .rank-item-zero {
    color: #000;
    font-weight: 500;
  }
  .rank-item {
    text-align: center;
    // line-height: 34px;
    height: 40px;
    color: #666;
    img {
      width: 22px;
    }
    .site {
      color: #26a978;
    }
  }
}
</style>
