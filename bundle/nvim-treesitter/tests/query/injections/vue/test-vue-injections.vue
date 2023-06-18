<template>
  <span>{{"Text inside interpolation"}}</span>
  <!--      ^ javascript -->

  <template lang="pug"> a(:href="url") some link title in pug: </template>
  <!--                                       ^ pug -->

  <template v-if="'text inside directives'"></template>
<!--              ^ javascript -->
</template>
<script> const foo = "1" </script>
<!--      ^ javascript -->
<script defer> const foo = "1" </script>
<!--              ^ javascript -->
<script lang="js">function x(){ return 1;}</script>
<!--                              ^ javascript -->
<script lang="ts"> const foo: number = "1" </script>
<!--                            ^ typescript -->
<!--                            ^ !javascript -->
<script lang="ts" defer>const foo: number = 1 </script>
<!--                            ^ typescript -->
<!--                            ^ !javascript -->
<script lang="tsx" defer>const foo: number = 1</script>
                              <!--  ^ tsx -->
                              <!--  ^ !jsx -->
                              <!--  ^ !typescript -->
<style> .bar { .foo{ } } </style>
<!--                ^ css   -->
<style scoped> .page.page--news { background: rebeccapurple; } </style>
<!--                ^ css  -->
<style lang="css"> .bar { justify-content: center; } </style>
<!--                ^ css  -->
<style lang="scss"> .bar { &-baz { } } </style>
<!--                       ^ scss -->
<!--                       ^ !css -->
<style scoped lang="scss">body{} </style>
<!--                       ^ scss -->
<!--                       ^ !css -->
