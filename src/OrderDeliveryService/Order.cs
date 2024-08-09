// Root myDeserializedClass = JsonConvert.DeserializeObject<Root>(myJsonResponse);
using Newtonsoft.Json;

namespace OrderDeliveryService.Models;

public class ItemOrdered
{
    [JsonProperty("catalogItemId")]
    public int CatalogItemId { get; set; } 

    [JsonProperty("productName")]
    public string ProductName { get; set; }

    [JsonProperty("pictureUri")]
    public string PictureUri { get; set; }
}

public class OrderItem
{
    [JsonProperty("itemOrdered")]
    public ItemOrdered ItemOrdered { get; set; }

    [JsonProperty("unitPrice")]
    public string UnitPrice { get; set; }

    [JsonProperty("units")]
    public int Units { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public class Order
{
    [JsonProperty("buyerId")]
    public string BuyerId { get; set; }

    [JsonProperty("orderDate")]
    public DateTime OrderDate { get; set; }

    [JsonProperty("shipToAddress")]
    public ShipToAddress ShipToAddress { get; set; }

    [JsonProperty("orderItems")]
    public List<OrderItem> OrderItems { get; set; }

    [JsonProperty("id")]
    public string Id { get; set; }
}

public class ShipToAddress
{
    [JsonProperty("street")]
    public string Street { get; set; }

    [JsonProperty("city")]
    public string City { get; set; }

    [JsonProperty("state")]
    public string State { get; set; }

    [JsonProperty("country")]
    public string Country { get; set; }

    [JsonProperty("zipCode")]
    public string ZipCode { get; set; }
}

