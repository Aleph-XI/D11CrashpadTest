#include "CrashpadSetup.hpp"

#include <cstdlib>
#include <iostream>

int main(int argc, const char** argv)
{
	std::cout << "Hello World" << std::endl;

	std::cout << backtrace::initializeCrashpad() << std::endl;

	std::cout << "Line: " << __LINE__ << " of file: " << __FILE__ << std::endl;

	std::abort();

	std::cout << "Goodbye World" << std::endl;

	return 1;
}
