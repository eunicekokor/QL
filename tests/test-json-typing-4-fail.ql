function increment(int c) : int {
  int x = c + 10
  return x
}
json a = json("dude.json")
increment(a["dude"])
string f = a["dude"]
