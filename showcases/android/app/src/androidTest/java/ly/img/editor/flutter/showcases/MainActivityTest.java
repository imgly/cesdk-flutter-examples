package ly.img.editor.flutter.showcases;

import androidx.test.rule.ActivityTestRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.Rule;
import org.junit.runner.RunWith;

// Entry point for Firebase Test Lab / `./gradlew connectedAndroidTest`: FlutterTestRunner
// discovers the Dart `integration_test/app_test.dart` tests and reports each as a JUnit case.
// The ActivityTestRule's `false` flag leaves MainActivity to be launched lazily by the runner.
@RunWith(FlutterTestRunner.class)
public class MainActivityTest {
  @Rule
  public ActivityTestRule<MainActivity> rule = new ActivityTestRule<>(MainActivity.class, true, false);
}
