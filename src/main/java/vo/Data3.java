package vo;
// 필드정보 은닉 + 캡슐화
public class Data3 {
	private int x; // 정보은닉
	private int y; // 정보은닉
	
	public int getX() { // 읽기 캡슐화 메소드
		return this.x;
	}
	public int getY() { // 읽기 캡슐화 메소드
		return this.y;
	}
	public void setX(int x) { // 쓰기 캡슐화 메소드
		this.x = x;
	}
	public void setY(int y) { // 쓰기 캡슐화 메소드
		this.y = y;
	}
	// Data d3_1 = new Data3();
	// d3_1.getX();
	// Data d3_2 = new Data3();
	// d3_2.getX();
}
