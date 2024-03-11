<script> import Button from "./Button.svelte"; </script>
<!--              ^ javascript -->
<script lang="ts"> const foo: number = 1 </script>
<!--                           ^ typescript -->
<!--                           ^ !javascript -->

<style> main { font-family: sans-serif; text-align: center; } </style>
<!--                       ^ css  -->
<style lang="scss"> main { &:hover { } } </style>
<!--                       ^ scss -->
<!--                       ^ !css -->

<main>
	<h1>Test file</h1>
  {#each someItems as someItem}
<!--          ^ javascript
-->
    <div>{someItem}</div>
<!--         ^ javascript 
-->
  {/each}
	<Button />
  <button on:click={() => foo++}></button>
</main>
