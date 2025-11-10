// condense a give localization text into a set of unique glyphs needed for a font spritesheet
//
// TODO: read srt files directly
// TODO: CJK: raise warnings on characters that aren't monospace (e.g. latin period)

const text = `亲爱的朋友们，
我很⾼兴能告诉你
昨晚我花了⼀个⼩时
通过收⾳机聆听
⻉多芬的第九交响曲。
昨晚，当全家⼈正在聆听
你精彩演绎
的不朽交响曲时
有⼈建议我把⼿放在
接收器上，看看是否能感觉
到震动
他拧开盖⼦
我轻轻地触碰敏感的振膜。
令我惊奇的是，
我不仅能感受到震动，
还有激昂的节奏，
⾳乐的悸动，和⾳乐的冲动。
交织交织的振动
从不同的乐器让我着迷。
我实际上可以分辨出短号，
⿎的作⽤，低⾳中提琴，
和⼩提琴，⼀起唱优美的歌曲。
⼩提琴优美的旋律
如何流淌，
并与其他乐器最深沉的⾳调交相辉映。
当⼈声响起时，
和谐浪潮的颤⾳，
我⽴刻就认出那是声⾳。
我感觉合唱变得更加欢快，
更加狂喜，更加弯曲，
更加迅速，更加⽕焰状。
直到我的⼼⼏乎停⽌跳动。
⼥声仿佛是
所有天使之声的化身
汇成⼀股和谐的洪流
发出美妙⽽⿎舞⼈⼼的声⾳。
伟⼤的合唱在我的指尖颤动，
伴随着凄美的停顿和流动。
然后所有的乐器和声⾳⼀起
迸发出⼀⽚天籁般的震颤
渐渐消逝，
如同原⼦耗尽后的⻛，
最终化为⼀阵细腻⽽甜美的⾳符⾬。
当然这不是“听觉”
但我确实知道那些⾳调与和声
传达给我⼀种⽆⽐美丽和庄严的氛围。
我还感受到，或者说我以为感受到了，
⼤⾃然温柔的声⾳
在我⼿中歌唱：
摇曳的芦苇，
还有⻛声，
还有潺潺的溪⽔。
我从未如此陶醉于
如此丰富的⾳调振动。
当我聆听⿊暗与旋律，
阴影与声⾳充满整个房间，
我不禁想起这位伟⼤的作曲家
为世界倾注了如此多甜蜜的洪流
却和我⼀样失聪。
我惊叹于他那永不熄灭的精神⼒量
他⽤⾃⼰的痛苦
为他⼈带来了如此的欢乐。
我坐在那⾥，⽤⼿感受着
那华丽的交响乐它像⼤海般
冲击着他和我灵魂的寂静海岸。
我要衷⼼感谢你们
美妙的⾳乐为我和我的家⼈
带来的所有欢乐。
致以最诚挚的问候和最美好的祝愿
我诚挚地敬你，
海伦凯勒`


const COLS = 25
const set = new Set()

for (let i=0; i < text.length; i++){
  if (text.charAt(i) != '\n'){
    set.add(text.charAt(i))
  }
}

console.log(set.size)
let s = ''

for (const char of set){
  s += char
  if (s.length===COLS){
    console.log(s)
    s = ''
  }
}

console.log(s)

// // unicode points
// for (let i=0; i<set.size; i++){
//   console.log(`map U+${s.codePointAt(i).toString(16)}=${i}`)
// }