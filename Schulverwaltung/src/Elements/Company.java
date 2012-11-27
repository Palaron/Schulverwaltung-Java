package Elements;

public class Company implements IDatabaseObject<Company>{
	private int id = -1;
	private String name = "";
	private String street = "";
	private String plz = "";
	private String city = "";
	private String phone = "";
	
	public Company()
	{
		
	}
	
	public Company(int id)
	{
		// Hier Firma nachladen
	}
	
	public int getId() {
		return id;
	}
	public Company setId(int id) {
		this.id = id;
		return this;
	}
	public String getName() {
		return name;
	}
	public Company setName(String name) {
		this.name = name;
		return this;
	}
	public String getStreet() {
		return street;
	}
	public Company setStreet(String street) {
		this.street = street;
		return this;
	}
	public String getPlz() {
		return plz;
	}
	public Company setPlz(String plz) {
		this.plz = plz;
		return this;
	}
	public String getCity() {
		return city;
	}
	public Company setCity(String city) {
		this.city = city;
		return this;
	}
	public String getPhone() {
		return phone;
	}
	public Company setPhone(String phone) {
		this.phone = phone;
		return this;
	}

	@Override
	public void addToDb() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void removeFromDb() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void save() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Company load() {
		// TODO Auto-generated method stub
		return this;
	}
}
