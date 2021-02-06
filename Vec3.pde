// written by Alhaitham

//Vector Library [2D]
//CSCI 5611 Vector 3 Library [Incomplete]

//Instructions: Add 3D versions of all of the 2D vector functions
//              Vec3 must also support the cross product.
public class Vec3 {
  public float x, y, z;
  
  public Vec3(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  public String toString(){
    return "(" + x+ ", " + y + ", " + z +")";
  }
  
  public float length(){
    return sqrt( x*x + y*y + z*z );
  }
  
  public Vec3 plus(Vec3 rhs){
    return new Vec3( x+rhs.x, y+rhs.y ,z+rhs.z);
  }
  
  public void add(Vec3 rhs){
    x += rhs.x;
    y += rhs.y;
    z += rhs.z;
  }
  
  public Vec3 minus(Vec3 rhs){
    return new Vec3(x-rhs.x, y-rhs.y, z-rhs.z);
  }
  
  public void subtract(Vec3 rhs){
    x -= rhs.x;
    y -= rhs.y;
    z -= rhs.z;
  }
  
  public Vec3 times(float rhs){
    return new Vec3(x*rhs, y*rhs, z*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
    z *= rhs;
  }
  
  public void normalize(){
    float mgt = sqrt( x*x + y*y + z*z );
    x /= mgt;
    y /= mgt;
    z /= mgt;
  }
  
  public Vec3 normalized(){
    float mgt = sqrt( x*x + y*y + z*z );
    return new Vec3( x/mgt, y/mgt ,z/mgt);
  }
  
  public float distanceTo(Vec3 rhs){
    return sqrt( (rhs.x-x)*(rhs.x-x) + (rhs.y-y)*(rhs.y-y) + (rhs.z-z)*(rhs.z-z) );
  }
}

Vec3 interpolate(Vec3 a, Vec3 b, float t){
  Vec3 res = a.plus((b.minus(a)).times(t));
  return res;
}

float dot(Vec3 a, Vec3 b){
  return a.x*b.x + a.y*b.y+ a.z*b.z;
}

Vec3 cross(Vec3 a, Vec3 b){
  float x_cross = a.y*b.z - a.z*b.y;
  float y_cross = a.z*b.x - a.x*b.z;
  float z_cross = a.x*b.y - a.y*b.x;
  return new Vec3(x_cross,y_cross,z_cross);
}

Vec3 projAB(Vec3 a, Vec3 b){
  return b.times(a.x*b.x + a.y*b.y+ a.z*b.z);
}
