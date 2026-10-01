<script lang="ts">
  import { onMount } from "svelte";
  import { slide } from "svelte/transition";

  type View = "overview" | "contacts" | "invoices";

  let view: View = "overview";
  let ContactAdmin: any;
  let ContactCount: any;
  let InvoiceAdmin: any;
  let InvoiceCreate: any;
  let InvoiceCount: any;
  let loading = true;
  let loadError = "";
  let showInvoiceForm = false;
  let invoiceVersion = 0;

  const views: View[] = ["overview", "contacts", "invoices"];
  const contactCountTranslations = { Contact: "Customers", ContactContact: "Customers" };
  const invoiceCountTranslations = { Invoice: "Invoices", InvoiceInvoice: "Invoices" };
  const contactTranslations = {
    nr: "Customer number",
    contact_type_id: "Contact type ID",
    name_1: "First or company name",
    name_2: "Last or additional name",
    salutation_id: "Salutation ID",
    salutation_form: "Salutation form",
    title_id: "Title ID",
    birthday: "Birthday",
    postcode: "Postal code",
    city: "City",
    country_id: "Country ID",
    mail: "Email",
    mail_second: "Secondary email",
    phone_fixed: "Phone",
    phone_fixed_second: "Secondary phone",
    phone_mobile: "Mobile phone",
    fax: "Fax",
    url: "Website",
    skype_name: "Skype name",
    remarks: "Remarks",
    language_id: "Language ID",
    contact_group_ids: "Contact group IDs",
    contact_branch_ids: "Contact branch IDs",
    user_id: "User ID",
    owner_id: "Owner ID",
    street_name: "Street",
    house_number: "House number",
    address_addition: "Address addition",
  };
  const contactSchema = {
    "field-properties": {
      "field-order": [
        "contact_type_id", "name_1", "name_2", "mail", "phone_mobile",
        "phone_fixed", "street_name", "house_number", "address_addition",
        "postcode", "city", "country_id", "language_id", "user_id",
        "owner_id", "remarks", "nr", "salutation_id", "salutation_form",
        "title_id", "birthday", "mail_second", "phone_fixed_second", "fax",
        "url", "skype_name", "contact_group_ids", "contact_branch_ids",
      ],
      "hidden-fields": ["id", "updated_at", "profile_image", "address", "is_lead"],
      "auto-generated-fields": ["id", "updated_at", "profile_image", "address", "is_lead"],
      "textarea-fields": ["remarks"],
    },
  };
  const invoiceTranslations = {
    title: "Title",
    contact_id: "Customer ID",
    contact_sub_id: "Contact person ID",
    user_id: "User ID",
    pr_project_id: "Project ID",
    logopaper_id: "Letterhead ID",
    language_id: "Language ID",
    bank_account_id: "Bank account ID",
    currency_id: "Currency ID",
    payment_type_id: "Payment type ID",
    header: "Header text",
    footer: "Footer text",
    mwst_type: "VAT type",
    show_position_taxes: "Show item taxes",
    is_valid_from: "Valid from",
    is_valid_to: "Valid until",
    contact_address_manual: "Customer address",
    reference: "Reference",
    api_reference: "API reference",
    template_slug: "Template",
  };
  const invoiceSchema = {
    visibility: { readOnly: true },
    "field-properties": {
      "field-order": [
        "contact_id", "contact_sub_id", "title", "user_id",
        "language_id", "currency_id", "payment_type_id", "bank_account_id",
        "is_valid_from", "is_valid_to", "header", "footer", "reference",
        "api_reference", "pr_project_id", "logopaper_id", "template_slug",
        "mwst_type", "show_position_taxes",
        "contact_address_manual",
      ],
      "hidden-fields": [
        "id", "project_id", "total_gross", "total_net", "total_taxes", "total",
        "total_remaining_payments", "contact_address", "kb_item_status_id",
        "updated_at", "network_link",
      ],
      "auto-generated-fields": [
        "id", "project_id", "total_gross", "total_net", "total_taxes", "total",
        "total_remaining_payments", "contact_address", "kb_item_status_id",
        "updated_at", "network_link",
      ],
      "boolean-fields": ["show_position_taxes"],
      "textarea-fields": ["header", "footer", "contact_address_manual"],
    },
  };

  onMount(async () => {
    try {
      const [contactAdmin, contactCount, invoiceAdmin, invoiceCreate, invoiceCount] = await Promise.all([
        import("App/Contact"),
        import("App/Contact/count"),
        import("App/Invoice"),
        import("App/Invoice/create"),
        import("App/Invoice/count"),
      ]);
      ContactAdmin = contactAdmin.default;
      ContactCount = contactCount.default;
      InvoiceAdmin = invoiceAdmin.default;
      InvoiceCreate = invoiceCreate.default;
      InvoiceCount = invoiceCount.default;
    } catch (error) {
      loadError = error instanceof Error ? error.message : "Generated modules could not be loaded.";
    } finally {
      loading = false;
    }
  });

</script>

<svelte:head><title>Bexio integration demo</title></svelte:head>

<main class="min-h-screen bg-slate-50 text-slate-900">
  <header class="border-b border-slate-200 bg-white">
    <div class="mx-auto max-w-7xl px-6 py-6">
      <p class="text-sm font-semibold uppercase tracking-widest text-rose-600">Bexio</p>
      <h1 class="mt-1 text-3xl font-bold">Customer and invoice management</h1>
    </div>
  </header>

  <div class="mx-auto max-w-7xl px-6 py-6">
    <nav class="mb-6 flex flex-wrap gap-2" aria-label="Demo sections">
      {#each views as item}
        <button
          class="rounded-lg px-4 py-2 text-sm font-semibold capitalize transition {view === item ? 'bg-slate-900 text-white' : 'bg-white text-slate-700 shadow-sm hover:bg-slate-100'}"
          style={view === item ? "background-color: #0f172a; color: #ffffff;" : ""}
          aria-current={view === item ? "page" : undefined}
          on:click={() => view = item}
        >{item}</button>
      {/each}
    </nav>

    {#if loading}
      <div class="rounded-xl border border-slate-200 bg-white p-8">Loading generated modules…</div>
    {:else if loadError}
      <div class="rounded-xl border border-red-200 bg-red-50 p-6 text-red-800">
        <strong>Unable to load the Grapple UI modules.</strong>
        <p class="mt-2 text-sm">{loadError}</p>
      </div>
    {:else if view === "overview"}
      <section class="grid gap-5 md:grid-cols-2">
        <article class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <h2 class="text-lg font-semibold">Customers</h2>
          <p class="mb-4 text-sm text-slate-500">Contacts available in the connected Bexio account.</p>
          <svelte:component this={ContactCount} translations={contactCountTranslations} />
          <button class="mt-5 text-sm font-semibold text-rose-700" on:click={() => view = "contacts"}>Manage customers →</button>
        </article>
        <article class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <h2 class="text-lg font-semibold">Invoices</h2>
          <p class="mb-4 text-sm text-slate-500">Invoices returned by the Bexio API.</p>
          <svelte:component this={InvoiceCount} translations={invoiceCountTranslations} />
          <button class="mt-5 text-sm font-semibold text-rose-700" on:click={() => view = "invoices"}>Manage invoices →</button>
        </article>
      </section>
    {:else if view === "contacts"}
      <section class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
        <div class="mb-5">
          <h2 class="text-xl font-semibold">Customers</h2>
          <p class="text-sm text-slate-500">Manage Bexio contacts through the generated Grapple admin module.</p>
        </div>
        <svelte:component this={ContactAdmin} schema={contactSchema} translations={contactTranslations} enableFilter={true} enableClearFilter={true} enableLoadMore={true} />
      </section>
    {:else}
      <section class="space-y-4">
        <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
          <div class="flex flex-wrap items-start justify-between gap-4">
            <div>
              <h2 class="text-xl font-semibold">Invoices</h2>
              <p class="text-sm text-slate-500">Browse and create Bexio invoices through generated Grapple modules.</p>
            </div>
            <button class="rounded-lg bg-slate-900 px-4 py-2 text-sm font-semibold text-white" style="background-color: #0f172a; color: #ffffff;" on:click={() => showInvoiceForm = !showInvoiceForm}>{showInvoiceForm ? "Close form" : "Create invoice"}</button>
          </div>

          {#if showInvoiceForm}
            <div class="mt-5 border-t border-slate-200 pt-5" transition:slide={{ duration: 180 }}>
              <h3 class="mb-3 text-lg font-semibold">Create invoice</h3>
              <svelte:component
                this={InvoiceCreate}
                schema={invoiceSchema}
                translations={invoiceTranslations}
                onSuccess={() => {
                  showInvoiceForm = false;
                  invoiceVersion += 1;
                }}
              />
            </div>
          {/if}
        </div>

        <section class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
          {#key invoiceVersion}
            <svelte:component this={InvoiceAdmin} schema={invoiceSchema} translations={invoiceTranslations} enableFilter={true} enableClearFilter={true} enableLoadMore={true} />
          {/key}
        </section>
      </section>
    {/if}
  </div>
</main>
