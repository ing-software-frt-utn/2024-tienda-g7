Feature: Prueba Venta Backend
 
  Scenario: Enviar Venta a Backend
    Given una Venta
     |      key      |                value                 |
     |  receiptType  |               Factura                |
     | pointOfSaleId | 55555555-5555-5555-5555-555555555555 |
      And un Cliente
      |        key         |         value         |
      |   documentNumber   |        12345678       |
      |       cuit         |     20-12345678-5     |
      |    socialReason    |      Cliente S.A.     |
      |    homeAddress     |  Calle Principal 123  |
      | tributaryCondition | Responsable inscripto |
      And un Tipo de Pago
      |         key         |      value       |
      |        type         |   Credit card    |
      |     cardNumber      | 4507990000004905 |
      |   cardHolderName    |    Juan Pérez    |
      | cardExpirationMonth |        08        |
      | cardExpirationYear  |        24        |
      | cardSecurityNumber  |       123        |
      | cardHolderDocument  |     25123456     |
      And Lineas de Venta
      | quantity |              productId               |
      |    5     | 55555555-5555-5555-5555-555555555555 |
      #|   100    | 77777777-7777-7777-7777-777777777777 |
    When envio estos datos al Backend
    Then obtengo la siguiente respuesta
    |   key    |   value  |
    |    type    |  Factura |
    | billType |     A    |
      And los siguiente items
      |         key         |                 value                |
      | Point of sale   | 55555555-5555-5555-5555-555555555555 |
      | Receipt Type: | Factura A |
      | Social Reason | Cliente S.A. |
      | Document number | 12345678 |
      | CUIT | 20-12345678-5 |
      | Home address | Calle Principal 123 |
      | Tributary condition | Responsable inscripto |
      | Artículo 2 | X5 $52800.0 |
      | Total: | $52800.0 |
     
