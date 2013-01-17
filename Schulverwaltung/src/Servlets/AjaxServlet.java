package Servlets;

import java.io.IOException;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Database.Database;
import Elements.*;

/**
 * Servlet implementation class AjaxServlet
 */
@WebServlet("/AjaxServlet")
public class AjaxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("Action");
		String resultText = "";
		if(action.equals("loadGroups"))
		{
			String grade = request.getParameter("GradeId");
			try(Database db = new Database())
			{
				ResultSet result = db.getDataRows("SELECT id FROM gradeGroup " +
						"WHERE Disableflag=0 " +
						"AND GradeId=? ORDER BY Description", grade);
				while(result.next())
				{
					Group group = new Group().setId(result.getInt(1)).load();
					resultText += group.getDescription() + ";" + group.getId() + "|";
				}
				
				if(resultText != "")
				{
					resultText = resultText.substring(0, resultText.length() - 1);
				}
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		if(action.equals("loadAvailableSubjects"))
		{
			String groupId = request.getParameter("GroupId");
			try(Database db = new Database())
			{
				ResultSet result = db.getDataRows("SELECT group2subject.id, roomid, teacherid, subjectId FROM group2subject INNER JOIN subject ON subject.id = subjectId WHERE group2subject.Disableflag=0 AND GroupId=? ORDER BY Description", groupId);
				while(result.next())
				{
					Room room = new Room().setId(result.getInt("roomId")).load();
					Teacher teacher = new Teacher().setId(result.getInt("teacherId")).load();
					Subject subject = new Subject().setId(result.getInt("subjectId")).load();
					resultText += subject.getShortName() + " - " + 
								  teacher.getName() + " " + teacher.getFirstname() + " - " + 
								  room.getNumber() + ";" + result.getInt("id") + "|";
				}
				
				if(resultText != "")
				{
					resultText = resultText.substring(0, resultText.length() - 1);
				}
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		if(action.equals("loadHourDetails"))
		{
			String subjectId = request.getParameter("SubjectId");
			try (Database db = new Database())
			{
				ResultSet result = db.getDataRows("SELECT * FROM group2subject WHERE id=?", subjectId);
				while(result.next())
				{
					Teacher teacher = new Teacher().setId(result.getInt("teacherId")).load();
					Subject subject = new Subject().setId(result.getInt("subjectId")).load();
					Room room = new Room().setId(result.getInt("roomId")).load();
					resultText = teacher.getShortName() + ";" + subject.getShortName() + ";" + room.getNumber();
				}
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}	
		}
		
		if(action.equals("saveTimeTable"))
		{
			String groupId = request.getParameter("GroupId");
			String validTill = request.getParameter("ValidTill");
			try {
				TimeTable timeTable = new TimeTable().setGroupId(Integer.parseInt(groupId)).setValidTill(new SimpleDateFormat("dd.MM.yyyy").parse(validTill));
				timeTable.addToDb();
				resultText = String.valueOf(timeTable.getId());
			} 
			catch (Exception ex) 
			{
				ex.printStackTrace();
				resultText = "-1";
			}
		}
		
		if(action.equals("savePlanHour"))
		{
			try
			{
				String timeTableId = request.getParameter("TimeTableId");
				String hours = request.getParameter("Hours");
				if(hours != null && !hours.isEmpty())
				{
					String[] planHours = hours.split("|");
					System.out.println(planHours.toString());
					if(planHours != null && planHours.length > 0)
					{
						Database db = new Database();
						for(int i = 0; i < planHours.length; i++)
						{
							if(planHours[i] != null && !planHours[i].isEmpty())
							{
								String[] curHour = planHours[i].split(";");
								
								/*if(curHour != null && curHour.length == 3)
								{
									String weekDay = curHour[0];
									System.out.println(curHour[0]);
									String hour = curHour[1];
									String subjectId = curHour[2];
									System.out.println(weekDay + ";" + subjectId);
									try
									{
										/*db.NoQuery("INSERT INTO plan2hour(timetableid, subjectid, weekday, hour) VALUES (?,?,?,?)",
												timeTableId, subjectId, weekDay,  hour);
									}
									catch(Exception ex)
									{
										ex.printStackTrace();
									}
								}*/
							}
							resultText = "";
						}
						db.closeConnection();
					}
				}
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		if(action.equals("loadPlan"))
		{
			String groupId = request.getParameter("GroupId");;
			try (Database db = new Database())
			{
				int timeTableId = db.getInt("SELECT timetable.Id FROM timeTable " +
											"INNER JOIN plan2Hour On timetable.id = timetableid " +
											"INNER JOIN group2subject on group2subject.id = plan2hour.subjectid " +
											"WHERE group2subject.groupid = ? " +
											"ORDER BY validTill LIMIT 1", groupId);
				TimeTable timeTable = new TimeTable().setId(timeTableId).load();
				resultText = new SimpleDateFormat("dd.MM.yyyy").format(timeTable.getValidTill()) + "*";
				ResultSet result = db.getDataRows("SELECT group2subject.id, weekday, hour, group2subject.subjectId, teacherId, roomId FROM plan2hour INNER JOIN group2subject ON plan2hour.subjectid = group2subject.id WHERE timeTableId = ?", timeTableId);
				while(result.next())
				{
					Teacher teacher = new Teacher().setId(result.getInt("teacherId")).load();
					Subject subject = new Subject().setId(result.getInt("subjectId")).load();
					Room room = new Room().setId(result.getInt("roomId")).load();
					resultText += result.getInt("id") + ";" + (result.getInt("weekday") - 1) + ";" + (result.getInt("hour") - 1) + ";" + teacher.getShortName() + ";" + subject.getShortName() + ";" + room.getNumber() + "|";
				}
			}
			catch(Exception ex)
			{
		
				ex.printStackTrace();
			}
		}
		
		if(action.equals("addGroup"))
		{
			String gradeId = request.getParameter("GradeId");
			String description = request.getParameter("Description");
			System.out.println(gradeId);
			System.out.println(description);
			Group group = new Group().setDescription(description).setGradeId(Integer.parseInt(gradeId));
			group.addToDb();
			resultText = group.getId() + ";" + group.getDescription();
		}
		
		if(action.equals("loadGroupStudents"))
		{
			String groupId = request.getParameter("GroupId");
			Group group = new Group().setId(Integer.parseInt(groupId)).load();
			for(Student student:group.getStudents())
			{
				resultText += student.getId() + ";" + student.getName() + " " + student.getFirstname() + " - " + new SimpleDateFormat("dd.MM.yyyy").format(student.getBirthday()) + "|";
			}
		}
		System.out.println(action);
		response.setContentType("text/plain");
		response.getWriter().write(resultText);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}
}
