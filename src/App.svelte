<script lang="ts">
  import { onMount } from "svelte";
  import { slide } from "svelte/transition";

  type View = "overview" | "contacts" | "invoices";

  let view: View = "overview";
  let ContactCreate: any;
  let ContactEditor: any;
  let ContactCount: any;
  let InvoiceCreate: any;
  let InvoiceCount: any;
  let loading = true;
  let loadError = "";
  let customerId = "";
  let showContactForm = false;
  let showInvoiceForm = false;
  let editingContact: Record<string, any> | null = null;
  let allContacts: Array<Record<string, any>> = [];
  let allInvoices: Array<Record<string, any>> = [];
  let contactsLoading = false;
  let contactsError = "";
  let contactPage = 0;
  let invoicesLoading = false;
  let invoicesError = "";
  let invoicePage = 0;
  const pageSize = 10;
  $: contacts = allContacts.slice(contactPage * pageSize, (contactPage + 1) * pageSize);
  $: invoices = allInvoices.slice(invoicePage * pageSize, (invoicePage + 1) * pageSize);
  const views: View[] = ["overview", "contacts", "invoices"];
  const contactCountTranslations = {ContactContact: "Customers"};
  const invoiceCountTranslations = {InvoiceInvoice: "Invoices"};
  const contactTranslations = {
    nr: "Customer number",
    contact_type_id: "Contact type ID",
    name_1: "First or company name",
    name_2: "Last or additional name",
    salutation_id: "Salutation ID",
    salutation_form: "Salutation form",
    titel_id: "Title ID",
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
  const contactFormSchema = {
    "field-properties": {
      "field-order": [
        "contact_type_id", "name_1", "name_2", "mail", "phone_mobile",
        "phone_fixed", "street_name", "house_number", "address_addition",
        "postcode", "city", "country_id", "language_id", "user_id",
        "owner_id", "remarks", "nr", "salutation_id", "salutation_form",
        "titel_id", "birthday", "mail_second", "phone_fixed_second", "fax",
        "url", "skype_name", "contact_group_ids", "contact_branch_ids",
      ],
      "hidden-fields": ["id", "updated_at", "profile_image", "address", "is_lead"],
      "auto-generated-fields": ["id", "updated_at", "profile_image", "address", "is_lead"],
      "textarea-fields": ["remarks"],
    },
  };
  const invoiceTranslations = {
    document_nr: "Document number",
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
    mwst_is_net: "Prices exclude VAT",
    show_position_taxes: "Show item taxes",
    is_valid_from: "Valid from",
    is_valid_to: "Valid until",
    contact_address_manual: "Customer address",
    delivery_address_type: "Delivery address type",
    delivery_address_manual: "Delivery address",
    reference: "Reference",
    api_reference: "API reference",
    template_slug: "Template",
  };
  const invoiceFormSchema = {
    "field-properties": {
      "field-order": [
        "contact_id", "contact_sub_id", "title", "document_nr", "user_id",
        "language_id", "currency_id", "payment_type_id", "bank_account_id",
        "is_valid_from", "is_valid_to", "header", "footer", "reference",
        "api_reference", "pr_project_id", "logopaper_id", "template_slug",
        "mwst_type", "mwst_is_net", "show_position_taxes",
        "contact_address_manual", "delivery_address_type", "delivery_address_manual",
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
      "boolean-fields": ["mwst_is_net", "show_position_taxes"],
      "textarea-fields": ["header", "footer", "contact_address_manual", "delivery_address_manual"],
    },
  };
  const apiEndpoint = `${(process.env.SVELTE_APP_REMOTE_URL)}/api`;

  onMount(async () => {
    try {
      const [contactCreate, contactUpdate, contactCount, invoiceCreate, invoiceCount] = await Promise.all([
        import("App/Contact/createBexioContact"),
        import("App/Contact/updateBexioContact"),
        import("App/Contact/countContact"),
        import("App/Invoice/createBexioInvoice"),
        import("App/Invoice/countInvoice"),
      ]);
      ContactCreate = contactCreate.default;
      ContactEditor = contactUpdate.default;
      ContactCount = contactCount.default;
      InvoiceCreate = invoiceCreate.default;
      InvoiceCount = invoiceCount.default;
      await Promise.all([loadContacts(), loadInvoices()]);
    } catch (error) {
      loadError = error instanceof Error ? error.message : "Generated modules could not be loaded.";
    } finally {
      loading = false;
    }
  });

  async function loadContacts() {
    contactsLoading = true;
    contactsError = "";
    contactPage = 0;
    try {
      const result = await fetch(`${apiEndpoint}/contacts`, {headers: {accept: "application/json"}});
      if (!result.ok) throw new Error(`Contact request failed with status ${result.status}.`);
      const body = await result.json();
      allContacts = Array.isArray(body) ? body : Array.isArray(body?.data) ? body.data : [];
    } catch (error) {
      allContacts = [];
      contactsError = error instanceof Error ? error.message : "Contacts could not be loaded.";
    } finally {
      contactsLoading = false;
    }
  }

  function editContact(contact: Record<string, any>) {
    editingContact = {...contact};
    showContactForm = false;
  }

  async function contactUpdated() {
    editingContact = null;
    await loadContacts();
  }

  async function loadInvoices() {
    invoicesLoading = true;
    invoicesError = "";
    invoicePage = 0;
    const customerIdValue = String(customerId ?? "").trim();
    const id = Number(customerIdValue);
    const path = customerIdValue && Number.isInteger(id) && id > 0
      ? `/invoices/by-contact/${id}`
      : "/invoices";

    try {
      const result = await fetch(`${apiEndpoint}${path}`, {headers: {accept: "application/json"}});
      if (!result.ok) throw new Error(`Invoice request failed with status ${result.status}.`);
      const body = await result.json();
      allInvoices = Array.isArray(body) ? body : Array.isArray(body?.data) ? body.data : [];
    } catch (error) {
      allInvoices = [];
      invoicesError = error instanceof Error ? error.message : "Invoices could not be loaded.";
    } finally {
      invoicesLoading = false;
    }
  }
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
      <section class="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
        <div class="mb-4 px-2 pt-2">
          <h2 class="text-xl font-semibold">Customers</h2>
          <p class="text-sm text-slate-500">List existing contacts or create a customer in Bexio.</p>
        </div>
        <div class="space-y-6">
          <div class="min-w-0 overflow-x-auto">
            <div class="mb-3 flex justify-end gap-2">
              <button class="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold" on:click={loadContacts}>Refresh</button>
              <button
                class="rounded-lg bg-slate-900 px-4 py-2 text-sm font-semibold text-white"
                style="background-color: #0f172a; color: #ffffff;"
                on:click={() => showContactForm = !showContactForm}
              >{showContactForm ? "Close form" : "Create customer"}</button>
            </div>
            {#if contactsLoading}
              <p class="p-4 text-sm text-slate-500">Loading contacts…</p>
            {:else if contactsError}
              <p class="rounded-lg bg-red-50 p-4 text-sm text-red-800">{contactsError}</p>
            {:else if contacts.length === 0}
              <p class="p-4 text-sm text-slate-500">No contacts found.</p>
            {:else}
              <table class="w-full text-left text-sm">
                <thead class="border-b border-slate-200 text-slate-500">
                  <tr>
                    <th class="px-3 py-2">Number</th>
                    <th class="px-3 py-2">Name</th>
                    <th class="px-3 py-2">Email</th>
                    <th class="px-3 py-2">City</th>
                    <th class="px-3 py-2 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {#each contacts as contact}
                    <tr class="border-b border-slate-100">
                      <td class="px-3 py-2">{contact.nr || contact.id || "–"}</td>
                      <td class="px-3 py-2">{[contact.name_1, contact.name_2].filter(Boolean).join(" ") || "–"}</td>
                      <td class="px-3 py-2">{contact.mail || "–"}</td>
                      <td class="px-3 py-2">{contact.city || "–"}</td>
                      <td class="px-3 py-2 text-right">
                        <button class="text-sm font-semibold text-slate-700 underline" on:click={() => editContact(contact)}>Edit</button>
                      </td>
                    </tr>
                  {/each}
                </tbody>
              </table>
            {/if}
            <div class="mt-4 flex items-center justify-between border-t border-slate-200 pt-3">
              <button
                class="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold disabled:cursor-not-allowed disabled:opacity-40"
                disabled={contactPage === 0 || contactsLoading}
                on:click={() => contactPage--}
              >Previous</button>
              <span class="text-sm text-slate-500">Page {contactPage + 1}</span>
              <button
                class="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold disabled:cursor-not-allowed disabled:opacity-40"
                disabled={(contactPage + 1) * pageSize >= allContacts.length || contactsLoading}
                on:click={() => contactPage++}
              >Next</button>
            </div>
          </div>
          {#if editingContact}
            <section class="rounded-xl border border-slate-300 bg-slate-50 p-5" transition:slide={{duration: 180}}>
              <div class="mb-5 flex items-start justify-between gap-4 border-b border-slate-200 pb-4">
                <div>
                  <h3 class="text-lg font-semibold">Edit customer</h3>
                  <p class="text-sm text-slate-500">Update contact #{editingContact.id} in Bexio.</p>
                </div>
                <button class="text-sm font-semibold text-slate-600" on:click={() => editingContact = null}>Close</button>
              </div>
              {#key editingContact.id}
                <svelte:component
                  this={ContactEditor}
                  formData={editingContact}
                  schema={contactFormSchema}
                  translations={contactTranslations}
                  onSuccess={contactUpdated}
                />
              {/key}
            </section>
          {/if}
          {#if showContactForm}
            <section class="rounded-xl border border-slate-200 bg-slate-50 p-5" transition:slide={{duration: 180}}>
              <div class="mb-5 border-b border-slate-200 pb-4">
                <h3 class="text-lg font-semibold">Create customer</h3>
                <p class="text-sm text-slate-500">Add a new contact to the connected Bexio account.</p>
              </div>
              <svelte:component this={ContactCreate} schema={contactFormSchema} translations={contactTranslations} onSuccess={loadContacts} />
            </section>
          {/if}
        </div>
      </section>
    {:else}
      <section class="space-y-4">
        <div class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
          <label for="customer-id" class="block text-sm font-semibold text-slate-700">Filter invoices by customer ID</label>
          <div class="mt-2 flex max-w-lg gap-2">
            <input
              id="customer-id"
              class="min-w-0 flex-1 rounded-lg border border-slate-300 px-3 py-2"
              type="number"
              min="1"
              bind:value={customerId}
              placeholder="Bexio contact ID"
              on:keydown={(event) => event.key === "Enter" && loadInvoices()}
            />
            <button class="rounded-lg bg-slate-900 px-4 py-2 font-semibold text-white" on:click={loadInvoices}>Apply</button>
          </div>
          <p class="mt-2 text-xs text-slate-500">Clear the field and apply again to show all invoices.</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
          <div class="mb-4 flex items-start justify-between gap-4 px-2 pt-2">
            <div>
              <h2 class="text-xl font-semibold">Invoices</h2>
              <p class="text-sm text-slate-500">List existing invoices or create a draft invoice in Bexio.</p>
            </div>
            <button
              class="shrink-0 rounded-lg bg-slate-900 px-4 py-2 text-sm font-semibold text-white"
              style="background-color: #0f172a; color: #ffffff;"
              on:click={() => showInvoiceForm = !showInvoiceForm}
            >{showInvoiceForm ? "Close form" : "Create invoice"}</button>
          </div>
          <div class="space-y-6">
            <div class="min-w-0 overflow-x-auto">
              {#if invoicesLoading}
                <p class="p-4 text-sm text-slate-500">Loading invoices…</p>
              {:else if invoicesError}
                <p class="rounded-lg bg-red-50 p-4 text-sm text-red-800">{invoicesError}</p>
              {:else if invoices.length === 0}
                <p class="p-4 text-sm text-slate-500">No invoices found.</p>
              {:else}
                <table class="w-full text-left text-sm">
                  <thead class="border-b border-slate-200 text-slate-500">
                    <tr>
                      <th class="px-3 py-2">Document</th>
                      <th class="px-3 py-2">Title</th>
                      <th class="px-3 py-2">Contact</th>
                      <th class="px-3 py-2">Total</th>
                      <th class="px-3 py-2">Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    {#each invoices as invoice}
                      <tr class="border-b border-slate-100">
                        <td class="px-3 py-2">{invoice.document_nr || invoice.id || "–"}</td>
                        <td class="px-3 py-2">{invoice.title || "–"}</td>
                        <td class="px-3 py-2">{invoice.contact_id || "–"}</td>
                        <td class="px-3 py-2">{invoice.total || invoice.total_gross || "–"}</td>
                        <td class="px-3 py-2">{invoice.kb_item_status_id || "–"}</td>
                      </tr>
                    {/each}
                  </tbody>
                </table>
              {/if}
              <div class="mt-4 flex items-center justify-between border-t border-slate-200 pt-3">
                <button
                  class="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold disabled:cursor-not-allowed disabled:opacity-40"
                  disabled={invoicePage === 0 || invoicesLoading}
                  on:click={() => invoicePage--}
                >Previous</button>
                <span class="text-sm text-slate-500">Page {invoicePage + 1}</span>
                <button
                  class="rounded-lg border border-slate-300 px-3 py-2 text-sm font-semibold disabled:cursor-not-allowed disabled:opacity-40"
                  disabled={(invoicePage + 1) * pageSize >= allInvoices.length || invoicesLoading}
                  on:click={() => invoicePage++}
                >Next</button>
              </div>
            </div>
            {#if showInvoiceForm}
              <section class="rounded-xl border border-slate-200 bg-slate-50 p-5" transition:slide={{duration: 180}}>
                <div class="mb-5 border-b border-slate-200 pb-4">
                  <h3 class="text-lg font-semibold">Create invoice</h3>
                  <p class="text-sm text-slate-500">Create a new draft invoice in Bexio.</p>
                </div>
                <svelte:component this={InvoiceCreate} schema={invoiceFormSchema} translations={invoiceTranslations} onSuccess={loadInvoices} />
              </section>
            {/if}
          </div>
        </div>
      </section>
    {/if}
  </div>
</main>
