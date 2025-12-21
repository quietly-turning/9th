// condense a give localization text into a set of unique glyphs needed for a font spritesheet
//
// TODO: read srt files directly
// TODO: CJK: raise warnings on characters that aren't monospace (e.g. latin period)

const text = `日本語
親愛なる友人、
昨夜、ラジオでベートーヴェンの
交響曲第９番を聴いて
感銘を受けた事を
すごく喜んで伝えたい。
昨晩、家族と共に素晴らしい
演奏を聴いていた時、
誰かが私に、高声器に手を当て、
振動が感じられるか試してみたらどうか、と提案しました。
彼はキャップを外し、
私は敏感なダイヤフラムを軽く触りました。
驚く事に、
私は振動だけではなく、
情熱なリズム、あの鼓動、
あの強い衝動を感じた。
いろんな楽器の混ぜ合わせ、
全てに魅せられました。
コルネット、鼓の連打、
低音のヴィオラ、ヴァイオリン、
各楽器の美しい斉奏がよく区別できる。
愛しいヴァイオリンの演説が
他の楽器の低音と完全に馴染んでる。
人が歌い始めた時、
震えた声が和音に加わり、
直ちに人の声と見分けられた。
合唱が意気揚揚で、
夢中に高鳴る
電光石火のように感じる、
私の心が躍る。
女の声が天使の声の具現化のように、
その美しい感動させる声が
洪水のように流れていく。
この素晴らしい合唱が指に伝わって、
私の胸に刺さった。
全ての楽器と声が、
漣のように、
その後消えた、
まるで風が吹いて微塵になるように、
甘い音符がポツポツと終わりました。
もちろん、これは「聴覚」ではない、
でも、この音調とハーモニーは
音楽の美しさと威厳が伝わってくる。
そして、柔らかな自然の音が
私の手が感じてる、
少なくとも、私はそう思ってる：
揺れる葦と、
風と、
川の囁き。
こんなにも
豪快な音楽に魅了された事がなかった。
暗闇と旋律に伴い、
影と音が部屋に溢れている、
私と同じく耳が聞こえない偉大な作曲家が
如何なる甘い音楽を
この世界に注いだか。
彼の尽きることのない精神の力に驚嘆した。
痛みの中から、
他者のためにあれほどの喜びを生み出したのだ。
そこに座って、
手で感じたその素晴らしい交響曲が
海みたいに静かな海岸を壊していく。
私達に届いた
この美しい音楽に感謝します。
心よりお礼申し上げます、
真心を込めて、
ヘレン・ケラー

`


const COLS = 20
const set = new Set()

console.log(text.length)
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