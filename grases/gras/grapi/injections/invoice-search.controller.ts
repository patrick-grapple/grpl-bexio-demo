import {HttpErrors, get, param, response} from '@loopback/rest';

const INVOICE_ARRAY_RESPONSE = {
  description: 'Bexio invoices belonging to one contact',
  content: {
    'application/json': {
      schema: {
        type: 'array',
        items: {type: 'object'},
      },
    },
  },
};

export class InvoiceSearchController {
  @get('/invoices/by-contact/{contactId}')
  @response(200, INVOICE_ARRAY_RESPONSE)
  async findByContact(
    @param.path.number('contactId') contactId: number,
    @param.query.number('limit') limit = 10,
    @param.query.number('offset') offset = 0,
  ): Promise<unknown[]> {
    const token = process.env.BEXIO_TOKEN;
    if (!token) {
      throw new HttpErrors.InternalServerError('BEXIO_TOKEN is not configured');
    }

    const bexioResponse = await fetch(
      `https://api.bexio.com/2.0/kb_invoice/search?limit=${limit}&offset=${offset}`,
      {
        method: 'POST',
        headers: {
          accept: 'application/json',
          authorization: `Bearer ${token}`,
          'content-type': 'application/json',
        },
        body: JSON.stringify([
          {field: 'contact_id', value: String(contactId), criteria: '='},
        ]),
      },
    );

    if (!bexioResponse.ok) {
      const details = await bexioResponse.text();
      throw new HttpErrors.BadGateway(
        `Bexio invoice search failed (${bexioResponse.status}): ${details}`,
      );
    }

    return (await bexioResponse.json()) as unknown[];
  }
}
