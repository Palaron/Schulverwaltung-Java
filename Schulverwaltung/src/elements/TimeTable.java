package elements;

import java.sql.ResultSet;
import java.util.Date;

import database.Database;
import database.Error;


public class TimeTable implements IDatabaseObject<TimeTable>{
	private int id = -1;
	private int disableflag = -1;
	private Date validTill = new Date();
	private int groupId = -1;
	public int getGroupId() {
		return groupId;
	}
	public TimeTable setGroupId(int groupId) {
		this.groupId = groupId;
		return this;
	}
	public int getId() {
		return id;
	}
	public TimeTable setId(int id) {
		this.id = id;
		return this;
	}
	public Date getValidTill() {
		return validTill;
	}
	public TimeTable setValidTill(Date validTill) {
		this.validTill = validTill;
		return this;
	}
	public int getDisableflag() {
		return disableflag;
	}

	public void setDisableflag(int disableflag) {
		this.disableflag = disableflag;
	}
	@Override
	public void addToDb() {
		try(Database db = new Database())
		{
			int id = db.getInt("SELECT MAX(Id) FROM timetable");
			if(id == -1)
			{
				id = 1;
			}
			else
			{
				id++;
			}
			
			this.setId(id);
			db.NoQuery("INSERT INTO timetable(Id, validtill, disableflag)" +
					   " values(?,?,0)",
					   this.getId(), this.getValidTill());
		}
		catch(Exception ex)
		{
			Error.out(ex);
		}
	}
	@Override
	public void removeFromDb() {
		try (Database db = new Database())
		{
			db.NoQuery("UPDATE TimeTable SET Disableflag = 1 WHERE Id = ?", this.getId());
		}
		catch(Exception ex)
		{
			Error.out(ex);
		}
	}
	@Override
	public void save() {
		try(Database db = new Database())
		{
			db.NoQuery("update timetable set validTill = ?, disableflag  = ? where id = ?",
					this.getValidTill(),
					this.getDisableflag(),
					this.getId());
		}
		catch(Exception ex)
		{
			Error.out(ex);
		}
	}
	@Override
	public TimeTable load() {
		try(Database db = new Database())
		{
			ResultSet result = db.getDataRows("SELECT * FROM timetable WHERE Id=?", this.getId());
			while(result.next())
			{
				this.setValidTill(result.getDate("validTill"));
				this.setDisableflag(result.getInt("disableflag"));
			}
		}
		catch(Exception ex)
		{
			Error.out(ex);
		}
		return this;
	}
}