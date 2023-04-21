using System.Data;
using AlphaIndustries.Application.Database;
using Dapper;

namespace AlphaIndustries.Infrastructure.Database;
public class DapperDatabase<T> : IDatabase<T> where T : class
{
	private readonly IDbConnection _dbConnection;

	public DapperDatabase(IDbConnection dbConnection)
	{
		_dbConnection = dbConnection;
	}

	public async Task<IEnumerable<T>> GetAllAsync()
	{
		return await _dbConnection.QueryAsync<T>("SELECT * FROM YourEntityTable");
	}

	public async Task<T> GetByIdAsync(int id)
	{
		return await _dbConnection.QueryFirstOrDefaultAsync<T>("SELECT * FROM YourEntityTable WHERE Id = @Id", new { Id = id });
	}

	public async Task InsertAsync(T entity)
	{
		const string sql = @"INSERT INTO YourEntityTable (Prop1, Prop2, Prop3) VALUES (@Prop1, @Prop2, @Prop3);";
		await _dbConnection.ExecuteAsync(sql, entity);
	}

	public async Task UpdateAsync(T entity)
	{
		const string sql = @"UPDATE YourEntityTable SET Prop1 = @Prop1, Prop2 = @Prop2, Prop3 = @Prop3 WHERE Id = @Id;";
		await _dbConnection.ExecuteAsync(sql, entity);
	}

	public async Task DeleteAsync(T entity)
	{
		const string sql = @"DELETE FROM YourEntityTable WHERE Id = @Id;";
		await _dbConnection.ExecuteAsync(sql, entity);
	}
}
