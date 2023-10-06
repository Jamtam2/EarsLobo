public class License
{
    public string ActivationCode { get; set; }
    public LicenseType LicenseType { get; set; }  // Same Enum as mentioned above
    public DateTime Expiration { get; set; }  // Assuming DateTime again
    public int ProductID { get; set; }  // Assuming it's an int based on common practices
}

public enum LicenseType
{
    Trial,
    Standard
}
