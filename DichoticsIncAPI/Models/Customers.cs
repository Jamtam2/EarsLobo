using System.ComponentModel.DataAnnotations;

public class Customer
{
    [Key]
    public int CustomerID  { get; set; }
    public string Name { get; set; }
    public string? Company { get; set; }
    public string Email { get; set; }
}
