/*
 * arg0 arg1 arg2 arg3 arg4 arg5 arg6   arg7
 * PID       ID   Type           Module Function
 *
 * PID -> Erlang process ID. (String)
 * ID -> ID of the mesurement group, 801 for cowboy handler calls.
 * Type -> Indicates of this is a entry (1) or return (2).
 * Module - The module that was called. (string).
 *
 * run with: dtrace -s handler.d
 */



/*
 * This function gets called every time a erlang developper probe is
 * fiered, we filter for 801 and 1, so it gets executed when a handler
 * function is entered.
 */

erlang*:::user_trace-i4s4
/ arg2 == 801 && arg3 == 1 /
{
  /*
   * We cache the relevant strings
   */
  process = copyinstr(arg0);
  emodule = copyinstr(arg6);
  efun = copyinstr(arg7);
  /*
   * increase the invocation count for this combination of module
   * and function
   */
  @invocations[emodule, efun] = count();
  /*
   * and store the timestamp linked to process, module and function.
   */
  self->_t[process, emodule, efun] = timestamp;
}

erlang*:::user_trace-i4s4
/ arg2 == 801 && arg3 == 2 &&
  self->_t[copyinstr(arg0), copyinstr(arg6), copyinstr(arg7)] /
{
  /*
   * We cache the relevant strings
   */
  process = copyinstr(arg0);
  emodule = copyinstr(arg6);
  efun = copyinstr(arg7);
  /*
   * and save quantize the execution time for module and function.
   */
  @func[emodule, efun] = quantize((timestamp - self->_t[process,emodule,efun]));
}

/*
 * this gets executed every 10 sand we print the data.
 */
tick-10sec
{
  printa(@invocations);
  printa(@func);
}
