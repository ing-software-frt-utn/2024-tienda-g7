from behave import Given, When, Then
import requests

@Given("una Venta")
def givenVentaTable(context):
    context.dataVenta = {}
    for row in context.table:
        key = row["key"]
        value = row["value"]
        context.dataVenta[key] = value


@Given("un Cliente")
def givenClienteTable(context):
    context.dataCliente = {}
    for row in context.table:
        key = row["key"]
        value = row["value"]
        context.dataCliente[key] = value

@Given("un Tipo de Pago")
def givenPaymentTable(context):
    context.dataPayment = {}
    for row in context.table:
        key = row["key"]
        value = row["value"]
        context.dataPayment[key] = value

@Given("Lineas de Venta")
def givenOrdersLineTable(context):
    context.dataOrdersLine = []
    for row in context.table:
        data_row = {
            'quantity': int(row['quantity']),
            'productId': row['productId']
        }
        context.dataOrdersLine.append(data_row)

@When("envio estos datos al Backend")
def whenEviarVentaAlBackend(context):
#    URL = "http://589d-181-91-39-187.ngrok-free.app/orders"
    URL = "http://127.0.0.1:8080/orders"
    
    headers = {
        "Content-Type": "application/json"
    }

    body = {
        "salesLines":  context.dataOrdersLine,
        "receiptType": context.dataVenta["receiptType"],
        "client": {
            "documentNumber":     context.dataCliente["documentNumber"],
            "cuit":               context.dataCliente["cuit"],
            "socialReason":       context.dataCliente["socialReason"],
            "homeAddress":        context.dataCliente["homeAddress"],
            "tributaryCondition": context.dataCliente["tributaryCondition"]
        },
        "pointOfSaleId": context.dataVenta["pointOfSaleId"],
        "payment": {
            "type":                    context.dataPayment["type"],
            "cardInfo": {
                "cardNumber":          context.dataPayment["cardNumber"],
                "cardHolderName":      context.dataPayment["cardHolderName"],
                "cardExpirationMonth": context.dataPayment["cardExpirationMonth"],
                "cardExpirationYear":  context.dataPayment["cardExpirationYear"],
                "cardSecurityNumber":  context.dataPayment["cardSecurityNumber"],
                "cardHolderDocument":  context.dataPayment["cardHolderDocument"]
            }
        }
    }

    try:
        response = requests.post(URL, headers=headers, json=body)
        context.responseURL = response.json()
        #context.responseURL = test
    except Exception as ex:
        context.responseURL = None
        print(f"excepcion: {ex}", "\n")
        return f"excepcion: {ex}"
    
@Then("obtengo la siguiente respuesta")
def then1(context):
    context.responseDatos = {}
    
    for row in context.table:
        key = row["key"]
        value = row["value"]
        context.responseDatos[key] = value

    type     = context.responseURL.get('type')
    billType = context.responseURL.get('billType')
    
    assert context.responseDatos["type"] == type, "El type obtenido no coincide con el esperado"
    assert context.responseDatos["billType"] == billType, "El billType obtenido no coincide con el esperado"

@Then("los siguiente items")
def then2(context):
    expectedItems = [
        {
            "key": row["key"], 
            "value": row["value"]
        } 
        for row in context.table
    ]

    resultList = []

    for section in context.responseURL["sections"]:
        for item in section["items"]:
            resultList.append({"key": item["key"], "value": item["value"]})
   
    #print(f"\n {test}\n")
    assert resultList == expectedItems, "Los items en el JSON no coinciden con los datos esperados"
