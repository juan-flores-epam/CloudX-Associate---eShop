using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

using System.Text.Json;

namespace FunctionApp1
{
    public class OrderItemsReserver
    {
        private readonly ILogger<OrderItemsReserver> _logger;

        public OrderItemsReserver(ILogger<OrderItemsReserver> logger)
        {
            _logger = logger;
        }

        [Function("OrderItemsReserver")]
        [BlobOutput("test-sample/{name}.json")]
        public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequest req, string name)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            _logger.LogInformation(requestBody);
            // dynamic data = JsonSerializer.Deserialize<dynamic>(requestBody);
            // jsonc
            // name = name ?? data?.name;
            return new OkObjectResult(requestBody);
        }
    }
}
