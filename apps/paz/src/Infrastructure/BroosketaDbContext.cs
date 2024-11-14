using Microsoft.EntityFrameworkCore;

namespace Broosketa.Infrastructure;

public class BroosketaDbContext : DbContext
{
    public BroosketaDbContext(DbContextOptions<BroosketaDbContext> options)
        : base(options) { }
}
