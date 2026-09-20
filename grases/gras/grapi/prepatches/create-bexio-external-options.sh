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
      "titel_id": {
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
    }
  },
  {
    "ds": "external",
    "controller": "Contact",
    "apiUri": "/contacts",
    "url": "https://api.bexio.com/2.0/contact",
    "apiFunction": "fetchBexioContacts",
    "count": true,
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
    "controller": "Contact",
    "apiUri": "/contacts/{id}",
    "description": "update contacts.",
    "url": "https://api.bexio.com/2.0/contact/{id}",
    "pathParams": {
      "id": {
        "type": "number",
        "required": true
      }
    },
    "modelName": "Contact",
    "apiFunction": "updateBexioContact",
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
      "titel_id": {
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
    }
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
    "description": "Create a Bexio invoice",
    "properties": {
      "document_nr": {
        "type": "string"
      },
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
      "mwst_is_net": {
        "type": "boolean"
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
      "delivery_address_type": {
        "type": "number"
      },
      "delivery_address_manual": {
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
    }
  },
  {
    "ds": "external",
    "controller": "Invoice",
    "apiUri": "/invoices",
    "url": "https://api.bexio.com/2.0/kb_invoice",
    "apiFunction": "fetchBexioInvoices",
    "modelName": "Invoice",
    "count": true,
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
  }
]
BEXIO_OPTIONS_JSON
