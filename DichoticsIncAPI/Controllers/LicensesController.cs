using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

[Route("api/[controller]")]
[ApiController]
public class LicensesController : ControllerBase
{
    private readonly AppDbContext _context;

    public LicensesController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/Licenses
    [HttpGet]
    public async Task<ActionResult<IEnumerable<License>>> GetLicenses()
    {
        return await _context.Licenses.ToListAsync();
    }

    // GET: api/Licenses/5
    [HttpGet("{id}")]
    public async Task<ActionResult<License>> GetLicense(int id)
    {
        var license = await _context.Licenses.FindAsync(id);
        if (license == null)
        {
            return NotFound();
        }

        return license;
    }

    // POST: api/Licenses
    [HttpPost]
    public async Task<ActionResult<License>> PostLicense(License license)
    {
        _context.Licenses.Add(license);
        await _context.SaveChangesAsync();

        return CreatedAtAction(nameof(GetLicense), new { id = license.LicenseID }, license);
    }

    // PUT: api/Licenses/5
    [HttpPut("{id}")]
    public async Task<IActionResult> PutLicense(int id, License license)
    {
        if (id != license.LicenseID)
        {
            return BadRequest();
        }

        _context.Entry(license).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!LicenseExists(id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    // DELETE: api/Licenses/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteLicense(int id)
    {
        var license = await _context.Licenses.FindAsync(id);
        if (license == null)
        {
            return NotFound();
        }

        _context.Licenses.Remove(license);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool LicenseExists(int id)
    {
        return _context.Licenses.Any(e => e.LicenseID == id);
    }
}
