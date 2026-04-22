import unittest
import warnings
import sys
import types

import numpy as np

if "object" not in np.__dict__:
    np.object = np.object_

if "mat73" not in sys.modules:
    mat73 = types.ModuleType("mat73")
    mat73.loadmat = lambda *args, **kwargs: None
    sys.modules["mat73"] = mat73

from AFDCal import AFDCal


class SetDicGenMethodTests(unittest.TestCase):
    def test_fast_afd_square_int_is_coerced_to_circle(self):
        afdcal = AFDCal()
        afdcal.setDecompMethod(2)

        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always")
            afdcal.setDicGenMethod(1)

        self.assertEqual(afdcal.dicGenMethod, 2)
        self.assertEqual(len(caught), 1)
        self.assertIn("automatically changed", str(caught[0].message))

    def test_fast_afd_invalid_int_still_raises(self):
        afdcal = AFDCal()
        afdcal.setDecompMethod(2)

        with self.assertRaises(ValueError):
            afdcal.setDicGenMethod(0)

    def test_fast_afd_square_string_is_coerced_to_circle(self):
        afdcal = AFDCal()
        afdcal.setDecompMethod(4)

        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always")
            afdcal.setDicGenMethod("square")

        self.assertEqual(afdcal.dicGenMethod, 2)
        self.assertEqual(len(caught), 1)
        self.assertIn("automatically changed", str(caught[0].message))

    def test_fast_afd_unknown_string_still_raises(self):
        afdcal = AFDCal()
        afdcal.setDecompMethod(4)

        with self.assertRaises(ValueError):
            afdcal.setDicGenMethod("cirlce")


if __name__ == "__main__":
    unittest.main()
