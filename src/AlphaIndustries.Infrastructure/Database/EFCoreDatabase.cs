using AlphaIndustries.Application.Database;
using Microsoft.EntityFrameworkCore;

namespace AlphaIndustries.Infrastructure.Database;
public class EntityFrameworkDatabase<T> : IDatabase<T> where T : class
{
	private readonly DbContext _dbContext;

	public EntityFrameworkDatabase(DbContext dbContext)
	{
		_dbContext = dbContext;
	}

	public async Task<IEnumerable<T>> GetAllAsync()
	{
		return await _dbContext.Set<T>().ToListAsync();
	}

	public async Task<T> GetByIdAsync(int id)
	{
		return await _dbContext.Set<T>().FindAsync(id);
	}

	public async Task InsertAsync(T entity)
	{
		_dbContext.Set<T>().Add(entity);
		await _dbContext.SaveChangesAsync();
	}

	public async Task UpdateAsync(T entity)
	{
		_dbContext.Entry(entity).State = EntityState.Modified;
		await _dbContext.SaveChangesAsync();
	}

	public async Task DeleteAsync(T entity)
	{
		_dbContext.Set<T>().Remove(entity);
		await _dbContext.SaveChangesAsync();
	}
}