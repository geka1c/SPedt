
//Процедура ПолучитьСтоимостьПоТарифуСДЭК() Экспорт
//	Отказ=Ложь;
//	стрЖСОН=ОбменДаннымиСДЭК.ПолучитьЖСОНСДЭКРасчитатьТариф(Ссылка);
//	
//	стрПротокол=новый Структура;
//	стрПротокол.Вставить("ОтправленныеДанные",стрЖСОН);
//	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
//	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.СтоимостьПоТарифу);

//	Ответ=ОбменДаннымиСДЭК.ОбменССайтомСтоимостьТарифа(стрЖСОН,Отказ);
//	
//	
//	Если Ответ<>неопределено Тогда
//		стрПротокол.Вставить("ПолученныеДанные",Ответ);
//		Протокол=ПротоколыПередач.Добавить();
//		структураЖсон=ОбменДаннымиСДЭК.РазобратьЖСОН(Ответ);
//		Если структураЖсон.Свойство("error") Тогда
//			РасчетКалькулятора="";
//			
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Возникли ошибки при расчете стоимости: ",,,,Отказ);
//			Для каждого элем из структураЖсон.error Цикл
//				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("код ошибки:"+элем.code+"; описание: "+элем.text,,,,Отказ);
//				РасчетКалькулятора=РасчетКалькулятора+"код ошибки:"+элем.code+"; описание: "+элем.text+Символы.ПС;
//			КонецЦикла;
//			стрПротокол.Вставить("Результат","error");
//		ИначеЕсли структураЖсон.Свойство("result") Тогда
//			стрПротокол.Вставить("Результат","Получена стоимость");
//			РасчетКалькулятора="сумма за доставку: "+структураЖсон.result.price+ " руб."+Символы.ПС+
//			"минимальная дата доставки: "+структураЖсон.result.deliveryDateMin+ " "+Символы.ПС+
//			"максимальная дата доставки: "+структураЖсон.result.deliveryDateMax+ " "+Символы.ПС+
//			"код тарифа: "+структураЖсон.result.tariffId;
//			ДопСбор=структураЖсон.result.price;
//		КонецЕсли;	

//		стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());

//		ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
//	КонецЕсли;
//	
//	
//КонецПроцедуры	