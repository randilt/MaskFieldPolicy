# MaskFieldPolicy

## Overview

Masks a specified JSON field in the API response, leaving only the last N characters visible. Useful for redacting sensitive fields (e.g. names, card numbers) from responses returned to API consumers, while the backend continues to return the field in full.

### Parameters

- **FieldName** — the JSON field name to mask (e.g. `payer_name`).
- **VisibleChars** — number of trailing characters to leave unmasked (e.g. `4`).