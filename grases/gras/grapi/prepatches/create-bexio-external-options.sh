#!/bin/sh
set -eu

# External operation definitions; executed before datasource/controller generation.
mkdir -p ./config
cat > ./config/bexio-options.json <<'BEXIO_OPTIONS_JSON'
[
  {
    "ds": "external",
    "method": "post",
    "controller": "Contact",
    "apiUri": "/contacts",
    "url": "https://api.bexio.com/2.0/contact",
    "createModel": true,
    "modelName": "Contact",
    "additionalProperties": {
      "id": {
        "type": "number",
        "required": false,
        "id": true
      },
      "updated_at": {
        "type": "string"
      },
      "profile_image": {
        "type": "string"
      },
      "address": {
        "type": "string"
      },
      "is_lead": {
        "type": "boolean"
      }
    },
    "apiFunction": "createBexioContact",
    "controllerFunction": "create",
    "responses": {
      "422": {
        "description": "Validation error",
        "schema": {
          "type": "object",
          "properties": {
            "error_code": {
              "type": "number"
            },
            "message": {
              "type": "string"
            }
          }
        }
      },
      "201": {
        "schema": {
          "type": "object",
          "model": "Contact"
        }
      }
    },
    "description": "POST Bexio contacts",
    "properties": {
      "nr": {
        "type": "string"
      },
      "contact_type_id": {
        "type": "number",
        "required": true
      },
      "name_1": {
        "type": "string",
        "required": true
      },
      "name_2": {
        "type": "string"
      },
      "salutation_id": {
        "type": "number"
      },
      "salutation_form": {
        "type": "number"
      },
      "title_id": {
        "type": "number"
      },
      "birthday": {
        "type": "string"
      },
      "postcode": {
        "type": "string"
      },
      "city": {
        "type": "string"
      },
      "country_id": {
        "type": "number"
      },
      "mail": {
        "type": "string"
      },
      "mail_second": {
        "type": "string"
      },
      "phone_fixed": {
        "type": "string"
      },
      "phone_fixed_second": {
        "type": "string"
      },
      "phone_mobile": {
        "type": "string"
      },
      "fax": {
        "type": "string"
      },
      "url": {
        "type": "string"
      },
      "skype_name": {
        "type": "string"
      },
      "remarks": {
        "type": "string"
      },
      "language_id": {
        "type": "number"
      },
      "contact_group_ids": {
        "type": "string"
      },
      "contact_branch_ids": {
        "type": "string"
      },
      "user_id": {
        "type": "number",
        "required": true
      },
      "owner_id": {
        "type": "number",
        "required": true
      },
      "street_name": {
        "type": "string"
      },
      "house_number": {
        "type": "string"
      },
      "address_addition": {
        "type": "string"
      }
    },
    "omitEmptyBodyProperties": true
  },
  {
    "ds": "external",
    "controller": "Contact",
    "apiUri": "/contacts",
    "url": "https://api.bexio.com/2.0/contact",
    "apiFunction": "fetchBexioContacts",
    "controllerFunction": "find",
    "localFilter": true,
    "count": true,
    "countFunction": "count",
    "modelName": "Contact",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "Contact"
        }
      }
    },
    "description": "GET Bexio contacts"
  },
  {
    "ds": "external",
    "controller": "Contact",
    "apiUri": "/contacts/{id}",
    "url": "https://api.bexio.com/2.0/contact/{id}",
    "apiFunction": "fetchBexioContact",
    "controllerFunction": "findById",
    "description": "fetch single contacts.",
    "modelName": "Contact",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "queryParams": {
      "show_archived": {
        "type": "boolean"
      }
    },
    "responses": {
      "200": {
        "schema": {
          "type": "object",
          "model": "Contact"
        }
      }
    }
  },
  {
    "ds": "external",
    "method": "post",
    "controllerMethod": "patch",
    "partial": true,
    "controller": "Contact",
    "apiUri": "/contacts/{id}",
    "description": "Update a Bexio contact.",
    "url": "https://api.bexio.com/2.0/contact/{id}",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "modelName": "Contact",
    "apiFunction": "updateBexioContact",
    "controllerFunction": "updateById",
    "responses": {
      "422": {
        "description": "Validation error",
        "schema": {
          "type": "object",
          "properties": {
            "error_code": {
              "type": "number"
            },
            "message": {
              "type": "string"
            }
          }
        }
      },
      "200": {
        "schema": {
          "type": "object",
          "model": "Contact"
        }
      }
    },
    "additionalProperties": {
      "address": {
        "type": "string"
      }
    },
    "properties": {
      "nr": {
        "type": "string"
      },
      "contact_type_id": {
        "type": "number",
        "required": true
      },
      "name_1": {
        "type": "string",
        "required": true
      },
      "name_2": {
        "type": "string"
      },
      "salutation_id": {
        "type": "number"
      },
      "salutation_form": {
        "type": "number"
      },
      "title_id": {
        "type": "number"
      },
      "birthday": {
        "type": "string"
      },
      "postcode": {
        "type": "string"
      },
      "city": {
        "type": "string"
      },
      "country_id": {
        "type": "number"
      },
      "mail": {
        "type": "string"
      },
      "mail_second": {
        "type": "string"
      },
      "phone_fixed": {
        "type": "string"
      },
      "phone_fixed_second": {
        "type": "string"
      },
      "phone_mobile": {
        "type": "string"
      },
      "fax": {
        "type": "string"
      },
      "url": {
        "type": "string"
      },
      "skype_name": {
        "type": "string"
      },
      "remarks": {
        "type": "string"
      },
      "language_id": {
        "type": "number"
      },
      "contact_group_ids": {
        "type": "string"
      },
      "contact_branch_ids": {
        "type": "string"
      },
      "user_id": {
        "type": "number",
        "required": true
      },
      "owner_id": {
        "type": "number",
        "required": true
      },
      "street_name": {
        "type": "string"
      },
      "house_number": {
        "type": "string"
      },
      "address_addition": {
        "type": "string"
      }
    },
    "omitEmptyBodyProperties": true
  },
  {
    "ds": "external",
    "method": "del",
    "controller": "Contact",
    "apiUri": "/contacts/{id}",
    "url": "https://api.bexio.com/2.0/contact/{id}",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "apiFunction": "deleteBexioContact",
    "controllerFunction": "deleteById",
    "modelName": "Contact",
    "responses": {
      "200": {
        "schema": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean"
            }
          }
        }
      }
    },
    "description": "DEL Bexio contacts"
  },
  {
    "ds": "external",
    "method": "post",
    "controller": "Invoice",
    "apiUri": "/invoices",
    "url": "https://api.bexio.com/2.0/kb_invoice",
    "createModel": true,
    "modelName": "Invoice",
    "apiFunction": "createBexioInvoice",
    "controllerFunction": "create",
    "description": "Create a Bexio invoice",
    "properties": {
      "title": {
        "type": "string"
      },
      "contact_id": {
        "type": "number"
      },
      "contact_sub_id": {
        "type": "number"
      },
      "user_id": {
        "type": "number"
      },
      "pr_project_id": {
        "type": "number"
      },
      "logopaper_id": {
        "type": "number"
      },
      "language_id": {
        "type": "number"
      },
      "bank_account_id": {
        "type": "number"
      },
      "currency_id": {
        "type": "number"
      },
      "payment_type_id": {
        "type": "number"
      },
      "header": {
        "type": "string"
      },
      "footer": {
        "type": "string"
      },
      "mwst_type": {
        "type": "number"
      },
      "show_position_taxes": {
        "type": "boolean"
      },
      "is_valid_from": {
        "type": "string"
      },
      "is_valid_to": {
        "type": "string"
      },
      "contact_address_manual": {
        "type": "string"
      },
      "reference": {
        "type": "string"
      },
      "api_reference": {
        "type": "string"
      },
      "template_slug": {
        "type": "string"
      }
    },
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "project_id": {
        "type": "number"
      },
      "total_gross": {
        "type": "string"
      },
      "total_net": {
        "type": "string"
      },
      "total_taxes": {
        "type": "string"
      },
      "total": {
        "type": "string"
      },
      "total_remaining_payments": {
        "type": "string"
      },
      "contact_address": {
        "type": "string"
      },
      "kb_item_status_id": {
        "type": "number"
      },
      "updated_at": {
        "type": "string"
      },
      "network_link": {
        "type": "string"
      },
      "document_nr": {
        "type": "string"
      },
      "total_received_payments": {
        "type": "string"
      },
      "total_credit_vouchers": {
        "type": "string"
      },
      "total_rounding_difference": {
        "type": "number"
      },
      "mwst_is_net": {
        "type": "boolean"
      },
      "viewed_by_client_at": {
        "type": "string"
      },
      "esr_id": {
        "type": "number"
      },
      "qr_invoice_id": {
        "type": "number"
      },
      "taxs": {
        "type": "array",
        "itemType": "object"
      },
      "positions": {
        "type": "array",
        "itemType": "object"
      }
    },
    "responses": {
      "201": {
        "schema": {
          "type": "object",
          "model": "Invoice"
        }
      },
      "422": {
        "description": "Validation error",
        "schema": {
          "type": "object",
          "properties": {
            "error_code": {
              "type": "number"
            },
            "message": {
              "type": "string"
            }
          }
        }
      }
    },
    "omitEmptyBodyProperties": true
  },
  {
    "ds": "external",
    "controller": "Invoice",
    "apiUri": "/invoices",
    "url": "https://api.bexio.com/2.0/kb_invoice",
    "apiFunction": "fetchBexioInvoices",
    "controllerFunction": "find",
    "localFilter": true,
    "modelName": "Invoice",
    "count": true,
    "countFunction": "count",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "Invoice"
        }
      }
    },
    "description": "Fetch Bexio invoices"
  },
  {
    "ds": "external",
    "controller": "Invoice",
    "apiUri": "/invoices/{id}",
    "url": "https://api.bexio.com/2.0/kb_invoice/{id}",
    "apiFunction": "fetchBexioInvoice",
    "controllerFunction": "findById",
    "modelName": "Invoice",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "responses": {
      "200": {
        "schema": {
          "type": "object",
          "model": "Invoice"
        }
      }
    },
    "description": "Fetch a single Bexio invoice"
  },
  {
    "ds": "external",
    "method": "post",
    "controllerMethod": "patch",
    "partial": true,
    "controller": "Invoice",
    "apiUri": "/invoices/{id}",
    "description": "Update a Bexio invoice.",
    "url": "https://api.bexio.com/2.0/kb_invoice/{id}",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "modelName": "Invoice",
    "apiFunction": "updateBexioInvoice",
    "controllerFunction": "updateById",
    "responses": {
      "200": {
        "schema": {
          "type": "object",
          "model": "Invoice"
        }
      },
      "422": {
        "description": "Validation error",
        "schema": {
          "type": "object",
          "properties": {
            "error_code": {
              "type": "number"
            },
            "message": {
              "type": "string"
            }
          }
        }
      }
    },
    "properties": {
      "title": {
        "type": "string"
      },
      "contact_id": {
        "type": "number"
      },
      "contact_sub_id": {
        "type": "number"
      },
      "user_id": {
        "type": "number"
      },
      "pr_project_id": {
        "type": "number"
      },
      "logopaper_id": {
        "type": "number"
      },
      "language_id": {
        "type": "number"
      },
      "bank_account_id": {
        "type": "number"
      },
      "currency_id": {
        "type": "number"
      },
      "payment_type_id": {
        "type": "number"
      },
      "header": {
        "type": "string"
      },
      "footer": {
        "type": "string"
      },
      "mwst_type": {
        "type": "number"
      },
      "show_position_taxes": {
        "type": "boolean"
      },
      "is_valid_from": {
        "type": "string"
      },
      "is_valid_to": {
        "type": "string"
      },
      "contact_address_manual": {
        "type": "string"
      },
      "reference": {
        "type": "string"
      },
      "api_reference": {
        "type": "string"
      },
      "template_slug": {
        "type": "string"
      }
    },
    "omitEmptyBodyProperties": true
  },
  {
    "ds": "external",
    "method": "del",
    "controller": "Invoice",
    "apiUri": "/invoices/{id}",
    "url": "https://api.bexio.com/2.0/kb_invoice/{id}",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "apiFunction": "deleteBexioInvoice",
    "controllerFunction": "deleteById",
    "modelName": "Invoice",
    "responses": {
      "200": {
        "schema": {
          "type": "object",
          "properties": {
            "success": {
              "type": "boolean"
            }
          }
        }
      }
    },
    "description": "Delete a Bexio invoice."
  },
  {
    "ds": "external",
    "controller": "LanguageLookup",
    "apiUri": "/lookups/languages",
    "url": "https://api.bexio.com/2.0/language",
    "modelName": "LanguageLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      },
      "iso_639_1": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioLanguages",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "LanguageLookup"
        }
      }
    },
    "description": "GET Bexio languages",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "CountryLookup",
    "apiUri": "/lookups/countries",
    "url": "https://api.bexio.com/2.0/country",
    "modelName": "CountryLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      },
      "iso3166_alpha2": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioCountries",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "CountryLookup"
        }
      }
    },
    "description": "GET Bexio countries",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "CurrencyLookup",
    "apiUri": "/lookups/currencies",
    "url": "https://api.bexio.com/3.0/currencies",
    "modelName": "CurrencyLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioCurrencies",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "CurrencyLookup"
        }
      }
    },
    "description": "GET Bexio currencies",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "PaymentTypeLookup",
    "apiUri": "/lookups/payment-types",
    "url": "https://api.bexio.com/2.0/payment_type",
    "modelName": "PaymentTypeLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioPaymentTypes",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "PaymentTypeLookup"
        }
      }
    },
    "description": "GET Bexio payment types",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "BankAccountLookup",
    "apiUri": "/lookups/bank-accounts",
    "url": "https://api.bexio.com/3.0/banking/accounts",
    "modelName": "BankAccountLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      },
      "iban": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioBankAccounts",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "BankAccountLookup"
        }
      }
    },
    "description": "GET Bexio bank accounts",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "UserLookup",
    "apiUri": "/lookups/users",
    "url": "https://api.bexio.com/3.0/users",
    "modelName": "UserLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "firstname": {
        "type": "string"
      },
      "lastname": {
        "type": "string"
      },
      "email": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioUsers",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "UserLookup"
        }
      }
    },
    "description": "GET Bexio users",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "ProjectLookup",
    "apiUri": "/lookups/projects",
    "url": "https://api.bexio.com/2.0/pr_project",
    "modelName": "ProjectLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "nr": {
        "type": "string"
      },
      "name": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioProjects",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "ProjectLookup"
        }
      }
    },
    "description": "GET Bexio projects",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "DocumentSettingLookup",
    "apiUri": "/lookups/document-settings",
    "url": "https://api.bexio.com/2.0/kb_item_setting",
    "modelName": "DocumentSettingLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "text": {
        "type": "string"
      },
      "kb_item_class": {
        "type": "string"
      },
      "default_logopaper_id": {
        "type": "number"
      }
    },
    "apiFunction": "fetchBexioDocumentSettings",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "DocumentSettingLookup"
        }
      }
    },
    "description": "GET Bexio document settings",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "DocumentTemplateLookup",
    "apiUri": "/lookups/document-templates",
    "url": "https://api.bexio.com/3.0/document_templates",
    "modelName": "DocumentTemplateLookup",
    "additionalProperties": {
      "template_slug": {
        "type": "string",
        "id": true
      },
      "name": {
        "type": "string"
      },
      "is_default": {
        "type": "boolean"
      }
    },
    "apiFunction": "fetchBexioDocumentTemplates",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "DocumentTemplateLookup"
        }
      }
    },
    "description": "GET Bexio document templates",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "SalutationLookup",
    "apiUri": "/lookups/salutations",
    "url": "https://api.bexio.com/2.0/salutation",
    "modelName": "SalutationLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioSalutations",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "SalutationLookup"
        }
      }
    },
    "description": "GET Bexio salutations",
    "createModel": true
  },
  {
    "ds": "external",
    "controller": "TitleLookup",
    "apiUri": "/lookups/titles",
    "url": "https://api.bexio.com/2.0/title",
    "modelName": "TitleLookup",
    "additionalProperties": {
      "id": {
        "type": "number",
        "id": true
      },
      "name": {
        "type": "string"
      }
    },
    "apiFunction": "fetchBexioTitles",
    "controllerFunction": "find",
    "responses": {
      "200": {
        "schema": {
          "type": "array",
          "model": "TitleLookup"
        }
      }
    },
    "description": "GET Bexio titles",
    "createModel": true
  }
]
BEXIO_OPTIONS_JSON
