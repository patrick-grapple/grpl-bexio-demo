<script lang="ts">
  let el: HTMLDivElement;
  import("App/Contact/count").then(({ default: Count }) => {
    new Count({ target: el, props: {
        // filter: { where:{ "postalCode":44000 } },
        // css: "background-color: rgb(204 90 113 / var(--tw-bg-opacity));"
        // css: "display: none;"
}});
  });
</script>

<div class="max-w-6xl m-auto p-8">
  <div bind:this={el} />
</div>
