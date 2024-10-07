
///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитов;
	
	Справочники.ХранилищеШаблонов.ЗаполнитьИменаРеквизитовПоТипуШаблона(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитов
	);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	//ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
	//	МассивВсехРеквизитов,
	//	МассивРеквизитов,
	//	МассивНепроверяемыхРеквизитов
	//);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры