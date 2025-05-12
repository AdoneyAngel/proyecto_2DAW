export default class TimeUtil {
  static calcPastTime (time:Date|string) {
    const pastTime = new Date(time)
    const actualDate = new Date()

    const diferenciaEnMilisegundos = Math.abs(actualDate.getTime() - pastTime.getTime());

    const seconds = Math.floor(diferenciaEnMilisegundos / 1000);
    const minutes = Math.floor(diferenciaEnMilisegundos / (1000*60));
    const hours = Math.floor(diferenciaEnMilisegundos / (1000*60*60));
    const days = Math.floor(diferenciaEnMilisegundos / (1000*60*60*24));

    const data = {
      days,
      hours,
      minutes,
      seconds
    }

    let string = ""

    if (data.days) {
      string = days + " days"

    } else if (data.hours) {
      string = hours + " hours"

    } else if (data.minutes) {
      string = minutes + " minutes"

    } else {
      string = seconds + " seconds"
    }

    return {
      data,
      string
    }

  }
}
