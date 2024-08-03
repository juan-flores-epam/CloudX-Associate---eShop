namespace Microsoft.eShopWeb;

public class AppFunctionSettings {
    public const string CONFIG_NAME = "appFunctions";
    public string AppName => CONFIG_NAME;
    public string? URL { get; set; }
    public string? ReserverEndpointName { get; set; }
}