using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Dapper;
using System.Data;
using Agency_API.Models;

[Route("api/exec")]
[ApiController]
public class ExecController : ControllerBase
{
    private readonly string _connectionString;

    public ExecController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [HttpPost]
    public async Task<IActionResult> ExecuteProcedure([FromBody] ExecRequest request)
    {
        try
        {
            if (request == null || string.IsNullOrWhiteSpace(request.ProcedureName))
            {
                return BadRequest("ProcedureName is required");
            }

            using (IDbConnection db = new SqlConnection(_connectionString))
            {
                var dynamicParameters = new DynamicParameters();

                if (request.Parameters != null)
                {
                    foreach (var param in request.Parameters)
                    {
                        var value = param.Value is System.Text.Json.JsonElement element
                                    ? element.GetRawText().Trim('"')
                                    : param.Value;

                        dynamicParameters.Add(param.Key, value);
                    }
                }

                var result = await db.QueryAsync(
                    request.ProcedureName,
                    dynamicParameters,
                    commandType: CommandType.StoredProcedure
                );

                return Ok(result);
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, ex.Message);
        }
    }
}
