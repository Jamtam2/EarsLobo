using System.ComponentModel.DataAnnotations;

public class License
{
     [Key]
    public int LicenseID  { get; set; }
    public string ActivationCode { get; set; }
    public LicenseType LicenseType { get; set; }  // Same Enum as mentioned above
    public DateTime Expiration { get; set; }  // Assuming DateTime again
    public int ProductID { get; set; }  // Assuming it's an int based on common practices
    public int CustomerID { get; set; }  // Assuming it's an int based on common practices
    public int? SubscriptiontID { get; set; }  // Assuming it's an int based on common practices
    public DateTime CreatedOnUtc { get; set; }  // Assuming DateTime again

}

public enum LicenseType
{
    Trial,
    Standard
}
