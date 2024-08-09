using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using OrderDeliveryService.Models;
using OrderDeliveryService.Services;

namespace OrderDeliveryService
{
    public class OrderDeliveryFunction
    {
        private readonly ILogger<OrderDeliveryFunction> _logger;
        private readonly IDbService _dbService;

        public OrderDeliveryFunction(ILogger<OrderDeliveryFunction> logger, IDbService dbService)
        {
            _logger = logger;
            _dbService = dbService;
        }

        [Function("OrderDeliveryFunction")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var container = _dbService.GetContainer();
            try
            {
                var order = JsonConvert.DeserializeObject<Order>(requestBody);
                //var order = JsonSerializer.Deserialize<Order>(requestBody);
                _logger.LogInformation($"Order: {order}");
                //_logger.LogInformation($"Order: {order.Resource}");
                var response = await container.CreateItemAsync<Order>(order);
                _logger.LogInformation($"Order created with id: {response.Resource.Id}");
                return new OkObjectResult(response.Resource.Id);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating order");
                return new BadRequestObjectResult($"Cannot parse body.");

            }
        }
    }
}
