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
        "type": "number"
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
    "apiFunction": "fetchBexioContact",
    "count": true,
    "queryParams": {
      "where": {
        "type": "object"
      }
    },
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
    "apiFunction": "fetchSingleBexioContact",
    "description": "fetch single contacts.",
    "modelName": "Contact",
    "pathParams": {
      "id": {
        "type": "number"
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
        "type": "number"
      }
    },
    "modelName": "Contact",
    "apiFunction": "editBexioContact",
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
        "type": "number"
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
        "type": "number"
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
  }
]
BEXIO_OPTIONS_JSON
