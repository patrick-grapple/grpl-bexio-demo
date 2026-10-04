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
  let lookupError = "";

  type DropdownOption = { label: string; value: string | number };
  type DropdownField = { name: string; options: DropdownOption[] };

  const apiBaseUrl = `${process.env.SVELTE_APP_REMOTE_URL}/api`;

  const views: View[] = ["overview", "contacts", "invoices"];
  const contactCountTranslations = { Contact: "Customers", ContactContact: "Customers" };
  const invoiceCountTranslations = { Invoice: "Invoices", InvoiceInvoice: "Invoices" };
  const contactTranslations = {
    nr: "Customer number",
    contact_type_id: "Contact type",
    name_1: "First or company name",
    name_2: "Last or additional name",
    salutation_id: "Salutation",
    salutation_form: "Salutation form",
    title_id: "Title",
    birthday: "Birthday",
    postcode: "Postal code",
    city: "City",
    country_id: "Country",
    mail: "Email",
    mail_second: "Secondary email",
    phone_fixed: "Phone",
    phone_fixed_second: "Secondary phone",
    phone_mobile: "Mobile phone",
    fax: "Fax",
    url: "Website",
    skype_name: "Skype name",
    remarks: "Remarks",
    language_id: "Language",
    contact_group_ids: "Contact group IDs",
    contact_branch_ids: "Contact branch IDs",
    user_id: "User",
    owner_id: "Owner",
    street_name: "Street",
    house_number: "House number",
    address_addition: "Address addition",
  };
  let contactSchema = {
    "field-properties": {
      "field-order": [
        "contact_type_id", "name_1", "name_2", "mail", "phone_fixed",
        "street_name", "house_number",
        "postcode", "city", "country_id", "language_id", "user_id",
        "owner_id", "remarks",
      ],
      "hidden-fields": [
        "id", "updated_at", "profile_image", "address", "is_lead",
        "phone_mobile", "address_addition", "salutation_id", "salutation_form",
        "title_id", "birthday", "mail_second", "phone_fixed_second", "fax",
        "url", "skype_name", "contact_group_ids", "contact_branch_ids",
      ],
      "auto-generated-fields": ["id", "updated_at", "profile_image", "address", "is_lead", "nr"],
      "textarea-fields": ["remarks"],
    },
  };
  const invoiceTranslations = {
    document_nr: "Document number",
    title: "Title",
    contact_id: "Customer",
    contact_sub_id: "Contact person",
    user_id: "User",
    project_id: "Project",
    pr_project_id: "Project",
    logopaper_id: "Letterhead",
    language_id: "Language",
    bank_account_id: "Bank account",
    currency_id: "Currency",
    payment_type_id: "Payment type",
    header: "Header text",
    footer: "Footer text",
    total_gross: "Gross total",
    total_net: "Net total",
    total_taxes: "Tax total",
    total_received_payments: "Received payments",
    total_credit_vouchers: "Credit vouchers",
    total_remaining_payments: "Remaining balance",
    total: "Total",
    total_rounding_difference: "Rounding difference",
    mwst_type: "VAT type",
    mwst_is_net: "Prices exclude VAT",
    show_position_taxes: "Show item taxes",
    is_valid_from: "Valid from",
    is_valid_to: "Valid until",
    contact_address: "Customer address",
    contact_address_manual: "Customer address",
    kb_item_status_id: "Status ID",
    reference: "Reference",
    api_reference: "API reference",
    viewed_by_client_at: "Viewed by customer at",
    updated_at: "Updated at",
    esr_id: "ESR ID",
    qr_invoice_id: "QR invoice ID",
    template_slug: "Template",
    taxs: "Taxes",
    positions: "Line items",
    network_link: "Network link",
  };
  let invoiceSchema = {
    "field-properties": {
      "field-order": [
        "contact_id", "title", "user_id",
        "language_id", "currency_id", "payment_type_id", "bank_account_id",
        "is_valid_from", "is_valid_to", "header", "footer", "mwst_type",
        "show_position_taxes",
      ],
      "hidden-fields": [
        "id", "project_id", "total_gross", "total_net", "total_taxes", "total",
        "total_remaining_payments", "contact_address", "kb_item_status_id",
        "updated_at", "network_link", "contact_sub_id", "reference",
        "api_reference", "pr_project_id", "logopaper_id", "template_slug",
        "contact_address_manual", "total_received_payments",
        "total_credit_vouchers", "total_rounding_difference", "viewed_by_client_at",
        "esr_id", "qr_invoice_id", "taxs", "positions",
      ],
      "auto-generated-fields": [
        "id", "project_id", "total_gross", "total_net", "total_taxes", "total",
        "total_remaining_payments", "contact_address", "kb_item_status_id",
        "updated_at", "network_link", "document_nr",
      ],
      "boolean-fields": ["show_position_taxes"],
      "textarea-fields": ["header", "footer", "contact_address_manual"],
    },
  };

  const option = (label: unknown, value: unknown): DropdownOption => ({
    label: String(label || value || ""),
    value: value as string | number,
  });

  const loadLookup = async (
    path: string,
    toOption: (item: Record<string, any>) => DropdownOption | null,
  ): Promise<DropdownOption[]> => {
    const response = await fetch(`${apiBaseUrl}${path}`);
    if (!response.ok) throw new Error(`${path} returned status ${response.status}`);
    const items = await response.json();
    return Array.isArray(items)
      ? items.map(toOption).filter((item): item is DropdownOption => item !== null && item.value !== undefined && item.value !== null)
      : [];
  };

  const addDropdowns = (schema: any, dropdowns: DropdownField[]) => ({
    ...schema,
    "field-properties": {
      ...schema["field-properties"],
      "dropdown-fields": dropdowns,
    },
  });

  const loadDropdowns = async () => {
    const lookups = await Promise.allSettled([
      loadLookup("/contacts", (item) => option(
        [item.name_1, item.name_2].filter(Boolean).join(" ") || item.nr,
        item.id,
      )),
      loadLookup("/lookups/languages", (item) => option(item.name, item.id)),
      loadLookup("/lookups/countries", (item) => option(`${item.name} (${item.iso_3166_alpha2})`, item.id)),
      loadLookup("/lookups/currencies", (item) => option(item.name, item.id)),
      loadLookup("/lookups/payment-types", (item) => option(item.name, item.id)),
      loadLookup("/lookups/bank-accounts", (item) => option(item.name, item.id)),
      loadLookup("/lookups/users", (item) => option(
        [item.firstname, item.lastname].filter(Boolean).join(" ") || item.email,
        item.id,
      )),
    ]);

    const values = lookups.map((result) => result.status === "fulfilled" ? result.value : []);
    const [contacts, languages, countries, currencies, paymentTypes, bankAccounts, users] = values;
    const failed = lookups.filter((result) => result.status === "rejected");
    if (failed.length) lookupError = `${failed.length} Bexio lookup list${failed.length === 1 ? "" : "s"} could not be loaded.`;

    contactSchema = addDropdowns(contactSchema, [
      { name: "contact_type_id", options: [option("Company", 1), option("Person", 2)] },
      { name: "country_id", options: countries },
      { name: "language_id", options: languages },
      { name: "user_id", options: users },
      { name: "owner_id", options: users },
    ]);

    invoiceSchema = addDropdowns(invoiceSchema, [
      { name: "contact_id", options: contacts },
      { name: "user_id", options: users },
      { name: "language_id", options: languages },
      { name: "currency_id", options: currencies },
      { name: "payment_type_id", options: paymentTypes },
      { name: "bank_account_id", options: bankAccounts },
      { name: "mwst_type", options: [
        option("Including VAT", 0),
        option("Excluding VAT", 1),
        option("VAT exempt", 2),
      ] },
    ]);
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
      await loadDropdowns();
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
        {#if lookupError}<p class="mb-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-800">{lookupError}</p>{/if}
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

          {#if lookupError}<p class="mt-4 rounded-lg bg-amber-50 p-3 text-sm text-amber-800">{lookupError}</p>{/if}

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
