<script>
  import dayjs from "dayjs";

  // demofullclassicmodelsasas
  let el1;
  import("App/Clients/count").then((module) => {
    const Count = module.default;
    new Count({
      target: el1,
      props: {
        // filter: { where:{ "postalCode":44000 } },
        // css: "background-color: rgb(204 90 113 / var(--tw-bg-opacity));"
        // css: "display: none;"
      },
    });
  });


</script>

<div class="max-w-6xl m-auto felx p-8">
  <!-- <div class="text-3xl">Customers, This is from the svelte application</div> -->

  <div class="p-8 grid gap-3">
    <div>
      <!-- <h2 class="text-xl">Count</h2> -->
      <div class="uimodule" bind:this={el1} style="width:350px;" />
    </div>
  </div>
</div>
