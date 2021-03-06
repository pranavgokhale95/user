object BinarySearch{
	var arr=new Array[Int](25);	

	def main(args:Array[String]){
		println("Enter sorted array");
		arr=scala.io.StdIn.readLine.split(" ").map(_.toInt);
		println("Enter value to find...");
		var key=scala.io.StdIn.readInt();
		Search(0,arr.length-1,key);
}


def Search(l:Int,r:Int,key:Int){
	if(r<l)
	{
	println("Not Found!");
	return;
	}

	if(r>=l){
	var mid=(l+r)/2;
	
	if(arr(mid)==key)
	{
	println(arr(mid)+" is found at position "+(mid+1));
	return;
	}
	if(l==r)
	{
	println("Not Found!");
	return;
	}
	if(arr(mid)>key)
	Search(l,mid-1,key);
	else
	Search(mid+1,r,key);
	}
	}
}
